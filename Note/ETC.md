깨알 공부 추가
==========
# 1. 화면 전환 (ViewController)

```swift
@objc func gotoAutoLayoutViewController(sender: UIButton) {
    let AutolayoutViewController = AutolayoutViewController()
    AutolayoutViewController.modalPresentationStyle = .fullScreen
    AutolayoutViewController.modalTransitionStyle = .coverVertical
    self.present(AutolayoutViewController, animated: true, completion: nil)
}

```
* self.present에 VC 넣음.
* VC.modalPresentationStyle 로 화면 구성 (.fullScreen 등) 설정 가능.
* VC.modalTransitionStyle 로 화면이 어떤식으로 등장 (.coverVertical 등) 할 지 애니메이션 설정 가능.


```swift
override func viewDidLoad() {
    super.viewDidLoad()
    
//        중략
    autoLayoutButton.addTarget(self, action: #selector(gotoAutoLayoutViewController), for: .touchUpInside)
//        중략
    
}
```
* addTarget으로 Action 추가 가능.

```swift
@objc func cancelButtonAction(sender: UIButton) {
    self.dismiss(animated: true, completion: nil)
}
```
* dismiss 로 이전 VC로 돌아감.

# 2. ignoreElements() -> Completable
```swift
public func ignoreElements()
    -> Observable<Never> {
    self.flatMap { _ in Observable<Never>.empty() }
    .asCompletable()
}
```
* 전에는 이렇게 Completable 로 자동으로 변환해줬음.

```swift
public func ignoreElements()
    -> Observable<Never> {
    self.flatMap { _ in Observable<Never>.empty() }
}
```
* 그러나 지금은 안해줌.
* 따라서 `someObservable.ignoreElements().asCompletable()` 이렇게 직접 적어주자.


# 3. Map vs. CompactMap
```swift
let optionalNumber: [Int?] = [1, 2, 3, 4, 5, nil, nil, 6, 7, 8]

let mapNumber = optionalNumber.map { $0 }
let compactMapNumber = optionalNumber.compactMap { $0 }
```
* `mapNumber` 는 옵셔널 값 그대로 `[Optional(1), Optional(2), Optional(3), Optional(4), Optional(5), nil, nil, Optional(6), Optional(7), Optional(8)]`
* `compactMapNumber` 는 옵셔널 값이 아닌 `[1, 2, 3, 4, 5, 6, 7, 8]`


# 4. Automatic Reference Counting (ARC)

* `Swift` 는 `App Memory` 를 다루기 위해 `ARC` 를 사용
* `ARC` 는 자동으로 더 이상 필요하지 않은 instance 들을 풀어준다 (해방한다, free up)

```swift
class Person {
    let name: String
    
    init(name: String) {
        self.name = name
        print("Init \(name)")
    }
    
    deinit {
        print("Deinit \(name)")
    }
}
```

* 먼저 ARC 가 작동하는 지 확인을 위한 Class 생성
```swift
var first: Person?
var second: Person?
var third: Person?
```

* `first` , `second`, `third` 를 선언

```swift
first = Person(name: "First Hogumachu")
// first 의 ARC + 1 (현재: 1)
// Init First Hogumachu
```

* first 에 Person 을 할당함으로 ARC 가 1이 증가하여 1이 되었음
* init 되었으므로 설정해둔 print 출력

```swift
second = Person(name: "Second Hogumachu")
// second 의 ARC + 1 (현재: 1)
// Init Second Hogumachu
```

* 위와 동일


```swift
third = second
// second 의 ARC + 1 (현재: 2)
```

* third 를 second 와 같은 것을 참조하게 함
* ARC 가 1 증가하여 2가 되었음

```swift
first = nil
// first 의 ARC - 1 (현재: 0)
// Deinit First Hogumachu
```
* first 를 nil 로 하여 ARC는 -1 이 되어 해당 reference 를 참조하는 것이 없으므로 deinit

```swift
second = nil
// second 의 ARC - 1 (현재: 1)

third = nil
// second의 ARC - 1 (현재: 0)
// Deinit Second Hogumachu
```
* second 를 nil 로 하였을 때는 아직 third 가 참조하고 있기 때문에 deinit 되지 않음
* third 를 nil 로 하였을 때 참조하는 것이 없으므로 deinit

## 4.1 Strong Reference Cycle

```swift
class Person {
    let name: String
    
    var bestFriend: Person?
    
    init(name: String) {
        self.name = name
        print("Init \(name)")
    }
    
    deinit {
        print("Deinit \(name)")
    }
}
```
* 위와 동일한 코드이나 `var bestFriend: Person?` 을 추가하였음

```swift
var john: Person?
var david: Person?

john = Person(name: "John")
// John ARC + 1 (현재: 1)
// Init John

david = Person(name: "David")
// David ARC + 1 (현재: 1)
// Deinit John
```

* John 과 David 라는 사람을 생성

```swift
john?.bestFriend = david
// David ARC + 1 (현재: 2)

david?.bestFriend = john
// John ARC + 1 (현재: 2)
```

* bestFriend 를 서로 선택하도록 함
* 따라서 ARC 가 각각 1씩 더 증가함

```swift
john = nil
// John ARC - 1 (현재: 1)

david = nil
// David ARC - 1 (현재: 1)
```

* 둘 다 nil 을 할당했으나 deinit 되지 않음
*  bestFriend 에서 서로를 참조하고 있는 `Strong Reference Cycle` 이 일어남

## 4.2 Weak & Unowned Reference

```swift
class Person {
    // 생략
    
    weak var bestFriend: Person?
    // var bestFriend: Person?
    
    // 생략
}
```

```swift
class Person {
    // 생략
    
    unowned var bestFriend: Person?
    // var bestFriend: Person?
    
    // 생략
}
```

* Weak reference: 약한 참조
* Unowned reference: 미소유 참조
* Reference count 를 증가시키지 않음
* 따라서 강한 순환 참조에 대한 문제 해결
* Weak 은 값에 nil 을 할당할 수 있지만, Unowned 는 nil 을 할당할 수 없음
* 즉, 미소유 참조는 옵셔널 타입이 불가능함.
