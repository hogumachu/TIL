# Struct 와 Class 그리고 Enum 의 차이

## Struct와 Class 의 공통점

* 프로퍼티 정의 (Define properties to store values)

* 메소드 정의 (Define methods to provide functionality)

* 서브스크립트를 정의 (Define subscripts to provide access to their values using subscript syntax)

* 초기화 (이니셜라이저) 정의 (Define initializers to set up their initial state)

* Extension 가능 (Be extended to expand their functionality beyond a default implementation)

* 프로토콜 준수 (Conform to protocols to provide standard functionality of a certain kind)



## Struct와 Class 의 차이점

### Struct

* Value Type: 값을 복사함

* 상속 불가능

### Class

* Reference Type: 값을 참조함. Reference counting
- 상속 가능 (Inheritance enables one class to inherit the characteristics of another)
- 타입 캐스팅을 사용하면 런타임에 클래스 인스턴스의 타입을 확인 및 (Type casting enables you to check and interpret the type of a class instance at runtime)
- Deinitializer를 통한 리소스 해제 (Deinitializers enable an instance of a class to free up any resources it has assigned)
- 참조 타입이기 때문에 Identity Operator 를 통해 참조 비교 가능



## Enum

* Value Type: 값을 복사함

* 상속 불가능

* 특정 타입으로 사용이 가능하며 원시 값 (rawValue) 존재 



## More

Collection (Array, Dictionary) 그리고 String은 최적화를 사용하여 복사 성능 비용을 줄임

즉시 복사본을 만드는 것이 아닌 먼저 저장된 메모리를 공유함

복사본 중 값이 수정되면 수정 직전에 복사함



## 출처

[Structures and Classes &mdash; The Swift Programming Language (Swift 5.7)](https://docs.swift.org/swift-book/LanguageGuide/ClassesAndStructures.html)
