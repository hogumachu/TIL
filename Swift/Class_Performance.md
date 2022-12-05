# Class 성능 향상 시킬 수 있는 방법

## 1. final 키워드

Method, Property 또는 subscript 를 final 키워드를 추가함으로 상속되는 것을 막을 수 있음

final 로 선언된 것은 직접 호출되고 그렇지 않은 것은 **vtable** 을 통해 간접 호출되어 느리게 동작함

final 로 선언된 것은 **Static Dispatch** 로 동작

### Dispatch

#### Static Dispatch

* **컴파일 타임**에 컴파일러가 호출될 함수를 결정

* **속도가 빠름**

#### Dynamic Dispatch

* **런타임**에 호출될 함수를 결정

* Swift 는 클래스마다 **vtable** 을 유지함

* **속도가 느림**

#### Dynamic Dispatch 사용 이유

* OOP 에서 핵심 메커니즘

* 다형성 때문; 메소드 구현이 선택되는 방식

## 2. private 키워드

한 Block 내에서만 참조되는 것을 보장

오버라이딩이 되는 곳이 없다면 Static Dispatch 로 동작

## 3. Class 쓰지 말자

Value Type 을 이용하여 Static Dispatch 가 되도록 하자

## vtable

가상 메소드 테이블

동적 디스패치를 지원하기 위해 프로그래밍 언어에서 사용되는 메커니즘

실행 기간 도중에 정확한 함수를 가리킴; 컴파일 타임에는 베이스 함수가 호출될 것인지 또는 베이스 클래스를 상속한 클래스에 의해서 구현될 지 알려져 있지 않기 때문

## 출처

[swift/OptimizationTips.rst at main · apple/swift · GitHub](https://github.com/apple/swift/blob/main/docs/OptimizationTips.rst#advice-use-final-when-you-know-the-declaration-does-not-need-to-be-overridden)

[가상 메소드 테이블 - 위키백과, 우리 모두의 백과사전](https://ko.wikipedia.org/wiki/%EA%B0%80%EC%83%81_%EB%A9%94%EC%86%8C%EB%93%9C_%ED%85%8C%EC%9D%B4%EB%B8%94)
