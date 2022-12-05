# Initialization

* Initialization 은 사용할 class, struct or enum의 instance 를 준비하는 프로세스
  각 저장 프로퍼티의 초기 값을 설정함

* Objective-C 초기화와 다르게 Swift 초기화는 값을 반환하지 않음

* Class 타입에는 Deinitializer 를 구현할 수 있음

## 

## Setting Initial Values for Stored Properties

instance 의 저장 프로퍼티를 사용하기 전 반드시 초기화 해야함

### Default Property Values

프로퍼티 선언과 동시에 값을 할당할 수 있음

```swift
struct User {
    var name = "홍길동"
}
```

## 

## Customizing Initialization

### Initialization Parameters

```swift
struct User {
    var name: String
    init(isFemale: Bool) {
        name = isFemale ? "김영희" : "김철수"
    }
}
```



## Default Initializers

모든 프로퍼티의 초기 값이 설정되어있으면 모든 프로퍼티를 기본 값으로 초기화하는 Default Initializer 를 제공함

```swift
struct User {
    var name = "홍길동"
    var age = 20
    var address: String?
}

var user = User()
```



## Class Inheritance and Initialization

### Designated init

클래스의 primary Initializer

클래스의 모든 프로퍼티가 초기화 해야 함

클래스 타입은 반드시 한 개 이상의 Designated initializer 가 있어야 함

```swift
// BAD: Class 'MyClass' has no initializers
class MyClass {
    var name: String
}


// GOOD
class MySecondClass {
    var name: String
    
    init(name: String) {
        self.name = name
    }
}
```

### Convenience init

**반드시 같은 클래스의 다른 Initializer 를 호출해야 함**

궁극적으로 Designated initializer 를 호출해야 함

```swift
class MyClass {
    var name: String
    var age: Int
    
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
    
    // BAD: 'self' used before 'self.init' call or assignment to 'self'
    convenience init(name: String) {
        self.name = name
        self.age = 20
    }
}

// GOOD
class MySecondClass {
    var name: String
    var age: Int
    
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
    
    convenience init(name: String) {
        self.init(name: name, age: 20)
    }
}


```
