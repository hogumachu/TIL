# Result

Swift 5 부터 등장함

말 그대로 결과에 대한 처리를 할 수 있는 문법

`Result<Value, Error>` 의 형태

```swift
@frozen public enum Result<Success, Failure> where Failure : Error {

    /// A success, storing a `Success` value.
    case success(Success)
    /// A failure, storing a `Failure` value.
    case failure(Failure)

}
```

**success** 와 **failure** 이라는 case 를 가진 **enum**

```swift
struct MyError: Error { }

extension Int {

    func isValid() -> Result<Void, Error> {
        return self > 0 ? .success(()) : .failure(MyError())
    }

}
```

결과가 성공일 때는 `success(Value)`

결과가 실패일 때는 `failure(Error)`

```swift
let a = -1

switch a.isValid() {
case .success:
    print("Success")

case .failure(let error):
    print("Failure: \(error.localizedDescription)")
}
```

switch 로 결과에 대한 핸들링을 할 수 있음



```swift
extension Result {
    
    func catchFailureJustReturn(_ s: Success) -> Success {
        switch self {
        case .success(let success):
            return success
        case .failure:
            return s
        }
    }
    
}

extension Int {
    
    func isValid() -> Result<String, Error> {
        return self > 0 ? .success(("Success")) : .failure(MyError())
    }
    
}

let message (a.isValid().catchFailureJustReturn("Catch Error")
print(message) // "Catch Error"
```

이런 식으로 활용도 가능함
