# String + Subscript

String은 Character 의 Collection

Swift는 Character 는 1개 이상의 Unicode Scalar 로 이루어져 있음; **Character 의 크기가 가변적**

따라서 **String.Index** 라는 구조체를 이용하여 인덱싱을 지원

이 String.Index 를 이용하여 Subscript 를 새로  정의하면 사용할 수 있긴함

```swift
extension String {
    subscript(index: Int) -> Character {
        let stringIndex = self.index(self.startIndex, offsetBy: index)
        return self[stringIndex]
    }
}

let str = "안녕😍하세요"
print(str[0]) // 안
print(str[1]) // 녕
print(str[2]) // 😍

```



## 출처

[Swift String 효율적으로 쓰기](https://jcsoohwancho.github.io/2019-11-19-Swift-String-%ED%9A%A8%EC%9C%A8%EC%A0%81%EC%9C%BC%EB%A1%9C-%EC%93%B0%EA%B8%B0/)
