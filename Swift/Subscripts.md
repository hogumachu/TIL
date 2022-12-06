# Subscripts

Class, Struct, Enum 은 subscripts 를 정의할 수 있음

collection, list, sequence 에 member elements에 간단하게 접근할 수 있는 문법



## 문법

```swift
subscript(index: Int) -> Int {
    get {
        // Return an appropriate subscript value here.
    }
    set(newValue) {
        // Perform a suitable setting action here.
    }
}

struct TimesTable {
    let multiplier: Int
    subscript(index: Int) -> Int {
        return multiplier * index
    }
}
let threeTimesTable = TimesTable(multiplier: 3)
print("six times three is \(threeTimesTable[6])")
// Prints "six times three is 18"
```



## 활용

Array 의 Subscript 를 활용해 index 에 안전하게 접근할 수 있음

```swift
extension Array {
    subscript(optional index: Int) -> Element? {
        return self.indices ~= index ? self[index] : nil
    }
}

let arr = [0, 1, 2]
print(arr[optional: 0]) // Optional(0)
print(arr[optional: 1]) // Optional(1)
print(arr[optional: 2]) // Optional(2)
print(arr[optional: 3]) // nil

```



## 출처

[Subscripts &mdash; The Swift Programming Language (Swift 5.7)](https://docs.swift.org/swift-book/LanguageGuide/Subscripts.html)
