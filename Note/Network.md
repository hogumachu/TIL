Network
==========
# 1. JSON,  URLSession

```swift
struct data: Codable {
    let data: String
}

```
* 캡스톤 디자인에서 챗봇 만들 때 사용한 JSON 형식.
* Codable = Encodable + Decodable


```swift
let urlStr = "http://127.0.0.1:8000/get_info/?data=\(chatTextField.text!)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
```
* Django 의 로컬 서버에 연결.
* 그 안에 있는 get_info 함수에 text를 주는 URL.

```swift
guard let url = URL(string: urlStr) else {
    fatalError("Invalid URL")
    return
}
```
* URL 이 올바르지 않으면 X

```swift
var request = URLRequest(url: url)
request.addValue("application/json", forHTTPHeaderField: "Content-Type")
request.httpMethod = "GET"
```
* URLRequest 를 생성하고 세팅을 해줌.

```swift
let task = URLSession.shared.dataTask(with: request) { closureData, response, error in
//            JSON 구조 이름이 다 data 라 closureData 라고 이름을 칭했음.
    if error != nil {
        print("Error in Task")
        return
    }
    guard let response = response as? HTTPURLResponse else {
        print("Error in Task #Response")
        return
    }
    
    guard (200...299).contains(response.statusCode) else {
        print("Error in Task #Response + \(response.statusCode)")
        return
    }
    
//            guardData라 한 것도 동일.
    guard let guardData = closureData else {
        print("Error in Tast #data")
        return
    }
    
    do {
        let decoder = JSONDecoder()
        
        let dataString = try decoder.decode(data.self, from: guardData)
        DispatchQueue.main.async {
//                    UI를 수정하기 위해 Main Thread에서 진행.
            self.botTextView.text = dataString.data
            print("data:", dataString.data)
        }
    } catch {
        print("Error")
        return
    }
}
task.resume()
```
* Error 일 때 return.
* Response가 이상할 때 return.
* StatusCode가 200번대가 아닐 경우 return.
* data가 이상할 때 return.
* 그렇지 않으면 decoder를 생성하여 decoding. 그리고 UI에 적용하기 위해 main thread 에서 UI를 변경.
* 설정이 다 끝이나면 resume 함.

<img src = "https://user-images.githubusercontent.com/74225754/126426432-0bbb7ced-b84f-476b-8d2d-ec18c7195e86.png" width="30%" height="30%"> <img src = "https://user-images.githubusercontent.com/74225754/126426471-5430c52f-db60-43d5-b667-8e37459dad65.png" width="60%" height="60%">

* 왼쪽은 iOS 실행 화면, 오른쪽은 Django 에서 실행 화면.


# 2. Reusable Request

```swift

func request(urlString: String, method: String, params: [String: Any]?, header: [String: String]?, completionHandler: @escaping (Bool, Any) -> Void) {
    // URL String 받은 것을 URL 로 변경
    let url = URL(string: urlString)!
    // URL 을 URLRequest 로 변경
    var urlRequest = URLRequest(url: url)
    
    // httpMethod 도 설정해줌
    urlRequest.httpMethod = method
    
    // 만약 헤더가 존재하면 추가
    if let header = header {
        header.forEach {
            urlRequest.addValue($0.value, forHTTPHeaderField: $0.key)
        }
    }
    
    // 만약 파라미터가 있다면 추가
    if let params = params {
        urlRequest.httpBody = try! JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
    }
    
    URLSession.shared.dataTask(with: urlRequest) { data, response, error in
        // 에러 처리
        if let error = error {
            print("Error:", error)
            return
        }
        
        // Response 에러 처리와 HTTPURLResponse 로 변경
        guard let response = response as? HTTPURLResponse else {
            print("Response Error")
            return
        }
        
        // 만약 상태 코드가 성공이 아닐 경우
        guard (200...299).contains(response.statusCode) else {
            print("Invalid StatusCode:", response.statusCode)
            return
        }
        
        // 데이터가 nil 일 경우
        guard let data = data else {
            print("Invalid Data")
            return
        }
        
        // 여기까지 왔다는 건 오류 없이 진행되었다는 얘기
        // completionHander 에 true 와 data 를 보냄
        completionHandler(true, data)
    }.resume()
}

```

* request 를 함수로 만들어 재사용 가능하게 함
* request 성공 시 completionHander 로 (true, data) 를 내보냄

```swift
let myURL = "My URL"

struct Hogumachu: Decodable {
    let name: String
    let age: Int
    let address: String?
}
```

* 만약 JSON 구조와 URL 이 이렇다면

```swift
// request 에 URL 과 method 그리고 params 와 header 를 작성
request(urlString: myURL, method: "GET", params: nil, header: ["Content-Type": "application/json"]) { success, data in
    // true 일 때
    if success {
        // 데이터를 해당 JSON 형식으로 변경하지 못하면 return
        guard let data = data as? Hogumachu else {
            print("Can't Convert Data")
            return
        }
        
        // 변경된 JSON 출력
        print(data.name)
        print(data.age)
        print(data.address ?? "No address")
        
    } else {
        print("Can't Find Data")
    }
}
```

* 이런 식으로 사용 가능
