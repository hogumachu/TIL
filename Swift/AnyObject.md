# AnyObject

> The **Protocol** to which all classes implicitly conform.

Type이 지정되지 않은 Object의 Flexibility 가 필요할 때 사용

Type이 지정되지 않은 결과를 반환하는 Bridge Objective-C 메소드 및 프로퍼티를 사용할 때 사용

AnyObject는 모든 클래스 타입의 인스턴스를 나타낼 수 있음

```swift
let s: AnyObject = "This is a bridged string." as NSString
print(s is NSString) // "true"

let v: AnyObejct = 100 as NSNumber
print(type(of: v) // "__NSCFNumber"
```



## Casting

type-case operator 를 이용하여 타입 캐스팅 가능

```swift
let anyObjectMessage: AnyObject = "Message"

if let message = anyObjectMessage as? String {
    // Do Something
}

let message = anyObjectMessage as! String
// Do Something

let anyObjectInt: AnyObject = 1
let anyObjects: [AnyObject] = [anyObjectMessage, anyObjectInt]

for object in anyObjects {
    switch obejct {
    case let m as String:
        // Do Something
    default:
        // Do Something
    }
}
```

## 출처

[Apple Developer Documentation](https://developer.apple.com/documentation/swift/anyobject)
