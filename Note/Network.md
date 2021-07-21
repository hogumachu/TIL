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
