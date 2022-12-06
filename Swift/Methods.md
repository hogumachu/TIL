# Methods

## Instance Methods

특정 class, struct, enum 에 속한 메소드

인스턴스가 속한 타입의 인스턴스에서만 실행이 가능함; 인스턴스를 생성해서 그 인스턴스를  통해서 접근 가능

## Type Methods

타입 메소드는 인스턴스 메소드와 동일하게 dot syntax 로 호출하지만 **해당 Type 의 인스턴스가 아닌 Type 의 메소드를 호출함**

인스턴스를 생성하지 않고 메소드를 호출해야 함

```swift
class SomeClass {
    class func someTypeMethod() {
        // type method implementation goes here
    }
}
SomeClass.someTypeMethod()
```

Type Method 에서의 self 는 해당 타입의 인스턴스가 아닌 타입 자체를 참조함

### Class & Static Methods

#### Class Method

오버라이딩이 가능함

#### Static Method

오버라이딩이 불가능함

```swift
class Animal {
    func greeting() {
        print("Barking")
    }

    static func staticGreeting() {
        print("Static Barking")
    }

    class func classGreeting() {
        print("Class Barking")
    }
}

class Human: Animal {
    override func greeting() {
        print("Hi")
    }

    // Error: Cannot override static method
    override static func staticGreeting() {
        print("Cannot override static method")
    }

    override class func classGreeting() {
        print("Class Hi")
    }
}

let hogumachu = Human()
hogumachu.greeting() // Instance Method
hogumachu.classGreeting() // ERROR: Static member 'classGreeting' cannot be used on instance of type 'Human'
```

## 출처

[Methods &mdash; The Swift Programming Language (Swift 5.7)](https://docs.swift.org/swift-book/LanguageGuide/Methods.html)
