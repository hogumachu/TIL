Optional
==========

```swift
@frozen public enum Optional<Wrapped> : ExpressibleByNilLiteral {
    case none
    case some(Wrapped)
}
```

* 값의 없음을 나타냄

* 래핑된 값 or 값이 없는 상태를 표현하는 형식

* enum 구조를 가지고 있음

* `Optional.none`으로 표현하지 않고 `nil` 로 표현

* In code, the absence of a value is typically written using the `nil` 
  literal rather than the explicit `.none` enumeration case.
