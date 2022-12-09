# Generic

사용자가 정의하는 요구 사항에 따라 모든 타입에서 작동할 수 있는 유연하고 **재사용 가능한 함수 및 타입을 작성**이 가능함; 중복된 코드를 피하고 추상화된 방식으로 표현 가능



## 예시

```swift
func swapTwoInts(_ a: inout Int, _ b: inout Int) {
    let temp = a
    a = b
    b = temp
}

func swapTwoDoubles(_ a: inout Double, _ b: inout Double) {
    let temp = a
    a = b
    b = temp
}
```

위 처럼 함수를 만들면 값에 따라 함수를 만들어야 함



```swift
func swapTwoValues<T>(_ a: inout T, _ b: inout T) {
    let temp = a
    a = b
    b = temp
}

var intA = 1
var intB = 2

swapTwoValues(&intA, &intB)


var stringA = "A"
var stringB = "B"

swapTwoValues(&stringA, &stringB)
```

Generic 을 사용하면 재사용 가능하게 사용할 수 있음



```swift
func request<Response: Decodable>(_ target: Target) async throws -> Response {
        do {
            var urlRequest = try self.encodeTarget(target)
            urlRequest.httpMethod = target.method.rawValue
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            try self.validateResponse(response: response)
            let result: Response = try self.decodeData(data: data)
            return result
        } catch {
            throw error
        }
    }
```

위처럼 `Decodable` 을 만족한다면 request 를 호출할 수 있음
