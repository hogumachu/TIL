RxSwift
==========
# 1. Observable, Observer, DisposeBag
## 1.1 Observable
* Observable은 Event를 발생시킴.

## 1.2 Observer
* Observable을 구독함 (Subscribe) .
* Observable이 발생시키는 Event를 구독하여 처리함.
* Observable이 Observer 에게 onCompleted 또는 onError 메시지를 보낼 때 Observable의 Life-cycle 종료.

```swift
Observable.from(["H", "O", "G", "U", "M", "A", "C", "H", "U"])
    .subscribe {
        print($0)
    }

```
* 단순히 클로저로 값을 받으면 next(value) 이런 식으로 값을 받음.


```swift
Observable.from(["H", "O", "G", "U", "M", "A", "C", "H", "U"])
    .subscribe {
        print($0.element)
    }
```
* $0.element로 값에 접근 가능.
* 값은 Optional.
* 마지막 값으로 nil이 전달되는 것을 보아 Completed 또는 Error 메시지가 오는 것 같음.

```swift
Observable.from(["H", "O", "G", "U", "M", "A", "C", "H", "U"])
    .subscribe {
        if let data = $0.element {
            print(data)
        } else {
            print("Not String")
            print($0)
        }
    }
```
* Optianl Binding 으로 값을 print 함
* 예상대로 $0 이 nil 일 때 설정해둔 "Not String" 과 함께 completed 메시지가 나옴.

## 1.3 DisposeBag
* Dispose: 사전적 의미로 처분하다.
* Observable이 발생한 이벤트를 Observer가 사용하고 그 후 Observable을 Dispose.
* 각각 .dispose() 을 추가하여 진행할 수 있지만 DisposeBag을 사용하는 것이 편리함.
* 만약 Dispose 하지 않으면 Observable이 사라지지 않아 메모리 누수 발생. (Dispose 하자)

```swift
var disposeBag = DisposeBag()

Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
    .subscribe {
        print("Hogumachu", $0)
    }
    .disposed(by: disposeBag)
// 1초에 1번씩 Hogumachu ~~ 를 print 하는 것을 disposeBag 에 넣었음
// 따로 정지시키지 않으면 (Dispose하지 않으면) 계속 진행함

DispatchQueue.global().asyncAfter(deadline: .now() + 10, execute: {
    disposeBag = DisposeBag()
})
// DisposeBag 이 빈 DisposeBag 으로 만들어질 때 DisposeBag 에 있는 task 들이 dispose 된다.
// Hogumachu next(0), ... ~~ next(9) 까지 진행되고 그 뒤로는 진행되지 않음 (Disposed)

```
* 먼저 disposeBag을 생성해줌
* Observable 마지막에 .disposed(by: disposeBag) 을 추가함으로 disposeBag 에 할당 되었음.
* 1초마다 계속 출력되는 Observable 이벤트를 Thread 에서 현재 시간 + 10초 뒤에 disposeBag을 비움.
* 10초 동안 반복되고 Dispose 되어 무한하게 반복되는 Event 가 해제되었음.


# 2. Subject (Publish, Behavior, Replay, Async), Relay
## 2.1 Publish Subject

```swift
let publishSubject = PublishSubject<Int>()
// 빈 PublishSubject 생성

publishSubject.onNext(1)

publishSubject.subscribe{
    print("Publish #1", $0)
}
.disposed(by: disposeBag)
// onNext로 1을 전달 후 subscribe 했지만 콘솔에는 아무 것도 출력되지 않음.

publishSubject.onNext(2)
// onNext로 2를 전달하니 next(2) 가 출력되었음.
// 먼저 subject를 subscribe 한 후 onNext로 element를 전달해야 함.

publishSubject.subscribe{
    print("Publish #2", $0)
}
.disposed(by: disposeBag)

publishSubject.onNext(3)

```
* 먼저 Subscribe 한 후 onNext로 Element를 전달해야 Subscriber 가 해당 값을 받을 수 있음.

## 2.2 Behavior Subject

```swift
let behaviorSubject = BehaviorSubject<Int>(value: 1)

behaviorSubject.subscribe {
    print("Behavior #1", $0)
}
.disposed(by: disposeBag)

behaviorSubject.onNext(2)

behaviorSubject.subscribe {
    print("Behavior #2", $0)
}
.disposed(by: disposeBag)

behaviorSubject.subscribe {
    print("Behavior #3", $0)
}
.disposed(by: disposeBag)

behaviorSubject.onNext(3)
```
* Publish Subject와 다른 점은 생성할 때 초기 값을 받음.
* `BehaviorSubject<Int>()` 이렇게 빈 상태로 생성 불가.

## 2.3 Replay Subject

```swift
let replaySubject = ReplaySubject<String>.create(bufferSize: 2)
let hogumachu = ["H", "O", "G", "U", "M", "A", "C", "H", "U"]

hogumachu.forEach{
    replaySubject.onNext($0)
}

replaySubject.subscribe{
    print("Replay #1", $0)
}
.disposed(by: disposeBag)
// bufferSize 만큼의 Element를 받음.
// 콘솔에 next(H), next(U) 가 출력되었음.

replaySubject.onNext("!")

// onNext에 !를 추가하니 onNext(U), onNext(!) 로 총 2개만 출력되는게 아닌 onNext(!) 가 추가되어 총 3개 출력

replaySubject.subscribe{
    print("Replay #2", $0)
}
.disposed(by: disposeBag)
// #2에서는 예상했던 2개 (U, !) 만 출력 되었음.

replaySubject.onCompleted()

replaySubject.subscribe{
    print("Replay #3", $0)
}
.disposed(by: disposeBag)
// #3는 !, completed 로 2개만 출력될 줄 알았으나 U, !, completed 가 출력되었음.
// onCompleted 는 Element로 구분하지 않는 듯.
```
* onNext로 받은 가장 최신의 Element 를 bufferSize 만큼 받음.
* 이미 Subscribe 중인 상태에서 onNext로 새로운 Element를 추가하면 추가적으로 Element를 받음 ( bufferSize + 1 의 Element를 받음. )
* onCompleted 와 onError는 Element로 구분하지 않는 듯.

## 2.4 Async Subject

```swift
let asyncSubject = AsyncSubject<String>()

hogumachu.forEach{
    asyncSubject.onNext($0)
    asyncSubject.subscribe{
        print("#1", $0)
    }
    .disposed(by: disposeBag)
}

// subscribe 해도 콘솔에 아무런 값이 나오지 않음.

asyncSubject.onCompleted()

// onCompleted 를 해야 값이 출력.
// 값이 배열의 가장 마지막 값만 배열의 사이즈 만큼 출력함.
// next(U) 를 9번 출력 후 Completed 도 9번 출력.
```
* onCompleted 를 해야 Subscriber 에게 Event를 전달함.
* 만약 onError 가 발생하면 onError 만 전달.

## 2.5 Relay (Publish Relay, Behavior Relay)

```swift
let publishRelay = PublishRelay<String>()

publishRelay.subscribe {
    print("PublishRelay #1", $0)
}

publishRelay.accept("Hogumachu")

let behaviorRelay = BehaviorRelay<String>(value: "Not Hogumachu")

behaviorRelay.subscribe{
    print("BehaviorRelay #1", $0)
}

behaviorRelay.accept("Hogumachu")

behaviorRelay.subscribe{
    print("BehaviorRelay #2", $0)
}
```

* 공식 문서에 `Unlike BehaviorSubject it can't terminate with error or completed.`, `Unlike PublishSubject it can't terminate with error or completed.`
* onError 나 onCompleted 도 끝낼 수 없음.
* onNext 로 값을 받는 것이 아닌 accept 로 받음.
