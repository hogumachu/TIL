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

# 3. Creating Observables
## 3.1 Create, Generate

```swift
Observable<Int>.create { observer in
    for i in 1...5 {
        observer.onNext(i)
    }
    observer.onCompleted()
    
    return Disposables.create()
}
.subscribe {
    print($0)
}
.disposed(by: disposeBag)
```

```swift
let str = "Hogumachu"

Observable
    .generate(
        initialState: str,
        condition: { $0.count < 13 },
        iterate: { $0 + "!" })
    .subscribe {
        print("Generate", $0)
    }
// Hoguamchu, Hogumachu!, Hogumachu!!, Hogumachu!!! 이렇게 $0.count가 12가 되고 종료.
```
* 직접적인 코드 구현을 통해 Observer 메소드를 호출하고 Observable 을 생성함.
* Generate 는 initialState 로 시작해서 condition의 조건까지 iterate에 있는 조건으로 반복함.

## 3.2 Defer

```swift
var isHoguamchu = false

let deferred = Observable<String>.deferred {
    if isHoguamchu {
        return Observable.just("Hogumachu")
    } else {
        return Observable.just("Not Hogumachu")
    }
}

deferred.subscribe {
    print($0)
}
.disposed(by: disposeBag)

isHoguamchu = true

deferred.subscribe {
    print($0)
}
.disposed(by: disposeBag)
```
* Observer 가 Subscribe 하기 전까지 Observable 생성을 지연.
* Subscribe가 시작 되면 Observer 별로 새로운 Observable 생성


## 3.3 Empty / Never / Error

```swift
Observable<Any>.empty()
    .subscribe {
        print($0)
    }
    .disposed(by: disposeBag)
```
* Empty 는 아무 것도 emit 하지 않고 일반적으로 끝남 (completed 만 하고 끝남).

```swift
Observable<Any>.never()
    .subscribe {
        print($0)
    }
    .disposed(by: disposeBag)
```
* Never 는 아무 것도 emit 하지 않고 그리고 끝나지 않음. (No completed, No error).

```swift
enum error: Error {
    case error
}

Observable.error(error.error)
    .subscribe {
        print($0)
    }
    .disposed(by: disposeBag)

```
* 공식 문서에서 Throw를 failWith 라고 했는데 error로 바뀌었음.
* 아무 것도 emit 하지 않고 error 한번 호출하고 끝남.

## 3.4 From

```swift
Observable
    .from(firstNumbers)
    .subscribe {
        print($0)
    }
    .disposed(by: disposeBag)

// Error Code
//Observable
//    .from(firstNumbers, secondNumbers)
//    .subscribe {
//        print($0)
//    }
//    .disposed(by: disposeBag)
//
```
* from 은 배열을 받고 배열 안에 있는 Element 로 나옴.
* 여러 개의 파라미터를 받는 것은 불가능.

## 3.5 Interval

```swift
Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
    .subscribe {
        print("Interval", $0)
    }
    .disposed(by: disposeBag)

DispatchQueue.global().asyncAfter(deadline: .now() + 10, execute: {
    disposeBag = DisposeBag()
})
```
* 1.3 참조.

## 3.6 Just

```swift
Observable
    .just(firstNumbers)
    .subscribe{
        print("Just", $0)
    }
    .disposed(by: disposeBag)
```
* just로 받은 값은 그대로 값이 나옴
* 배열이 들어가면 배열 안의 Element 를 하나 하나 받는 것이 아닌 배열 자체로 나옴.
* next([1, 2, 3, 4, 5, 6]), completed


## 3.7 Range

```swift
Observable
    .range(start: 0, count: 3)
    .subscribe {
        print("Range",$0)
    }
    .disposed(by: disposeBag)
```
* start 부터 시작해서 1씩 증가하여 총 count 번 출력함 (0, 1, 2)


## 3.8 Repeat Element


```swift
Observable
    .repeatElement("Hogumachu")
    .subscribe {
        print($0)
    }
 
```
* 무한 반복함
```swift
Observable
    .repeatElement("Hogumachu")
    .take(3)
    .subscribe {
        print("RepeatElement", $0)
    }
    .disposed(by: disposeBag)
```
* take 와 함께 사용하자


# 3. Filtering Observables

```swift
var disposeBag = DisposeBag()
let numbers = [0, 1, 2, 3, 4, 5,6 ,7 ,8, 9, 10]
```

## 3.1 Debounce
```swift
let debounceObserver = Observable<Int>.create { observer in
    DispatchQueue.global().async {
        numbers.forEach {
            observer.onNext($0)
            Thread.sleep(forTimeInterval: 0.5)
        }
        observer.onCompleted()
    }
    return Disposables.create()
}
```

```swift
debounceObserver
    .debounce(.seconds(1), scheduler: MainScheduler.instance)
    .subscribe { print("Debounce #1", $0) }
    .disposed(by: disposeBag)
```
* 10, completed
```swift
debounceObserver
    .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
    .subscribe { print("Debounce #2", $0) }
    .disposed(by: disposeBag)
```
* 0, 1, ..., 10, completed
* 시간 안에 Next 된 값 중에서 가장 최신 값을 방충


##  3.2 Distinct
```swift
Observable.from(numbers)
    .distinctUntilChanged()
    .subscribe { print("Distint #1", $0) }
    .disposed(by: disposeBag)
```
* 0, 1, ..., 10, completed

```swift
Observable.from([1, 1, 1, 2, 2, 3, 2, 3, 3, 2, 2])
    .distinctUntilChanged()
    .subscribe { print("Distint #2", $0) }
    .disposed(by: disposeBag)
```
* 1, 2, 3, 2, 3, 2 completed
* 중복된 값 (자신 바로 앞에 있는 값) 을 제거한 항목을 방출

##  3.3 ElementAt
```swift
Observable.from(numbers)
    .element(at: 3)
    .subscribe { print("ElementAt #1", $0)}
    .disposed(by: disposeBag)
```
* 해당 index에 있는 값을 방출
* index 값이 넘어가면 Error

##  3.4 Filter
```swift
Observable.from(numbers)
    .filter { $0 % 2 == 0 }
    .subscribe {
        print("Filter #1", $0)
    }
    .disposed(by: disposeBag)
```
* 0, 2, 4, 6, 8, 10, completed
* filter 의 조건에 따라 fitering 함


##  3.5 First (Single)
```swift
Observable.from(numbers)
    .single()
    .subscribe {
        print("First #1", $0)
    }
    .disposed(by: disposeBag)
// 0이 배출되고 completed가 아닌 error 발생
```
* 0, error
* from 으로 받는 numbers 가 1개를 넘기 때문

```swift
Observable.from(numbers)
    .single{
        $0 == 5
    }
    .subscribe {
        print("First #2", $0)
    }
    .disposed(by: disposeBag)
```
* 5가 배출되고 completed
* 값이 5인 것이 하나 밖에 없어서 정상적으로 진행
* Single 은 한 개의 값만 방출되어야 함.

##  3.6 IgnoreElements
```swift
Observable.from(numbers)
    .ignoreElements()
    .subscribe {
        print("IgnoreElements #1", $0)
    }
    .disposed(by: disposeBag)
```
* completed 인지 error 인지만 알려주고 나머지 요소는 무시함.

##  3.7 Sample
```swift
let sampleSubject = PublishSubject<Int>()
let sampleTrigger = PublishSubject<Int>()

sampleSubject.sample(sampleTrigger)
    .subscribe {
        print("Sample #1", $0)
    }
    .disposed(by: disposeBag)

sampleTrigger.onNext(1)
sampleSubject.onNext(1)

sampleTrigger.onNext(2)
sampleTrigger.onNext(2)

sampleSubject.onNext(2)

sampleTrigger.onNext(3)

sampleSubject.onCompleted()
sampleTrigger.onCompleted()
```
* Subject 가 먼저 onNext 되고 그 뒤로 Trigger가 onNext 되면 Subject 의 최신 값이 onNext 된다.
* 위의 예시는 Trigger 1, Subject 1 순서로 되어서 아직 방출 되지 않고
* Trigger 2가 되는 순간 Subject의 1이 방출
* 그 후 Trigger에 2를 줘도 아무 변화. 없고
* Subject에 2를 주고
* 그 뒤로 Trigger에 3을 주니 Subject의 2가 방출되었음.
* Completed 도 동일한 방식으로 진행.

##  3.8 Skip, SkipUntil, SkipWhile
### 3.8.1 Skip
```swift
Observable.from(numbers)
    .skip(3)
    .subscribe {
        print("Skip #1", $0)
    }
    .disposed(by: disposeBag)
```
* 3, 4, 5, 6, 7, 8, 9, 10, completed


```swift
Observable.from(numbers)
    .skip(100)
    .subscribe {
        print("Skip #2", $0)
    }
    .disposed(by: disposeBag)

```
* skip count가 index의 크기를 넘어가도 error 나지 않고 completed.
* Skip 은 Count 만큼 값을 skip.

### 3.8.2 SkipUntil
```swift
let skipUntilSubject = PublishSubject<Int>()
let skipUntilTrigger = PublishSubject<Int>()

skipUntilSubject.skip(until: skipUntilTrigger)
    .subscribe {
        print("SkipUntil #1", $0)
    }
    .disposed(by: disposeBag)

skipUntilSubject.onNext(1)

skipUntilTrigger.onNext(1)

numbers.forEach {
    skipUntilSubject.onNext($0)
}
```
* 트리거가 진행하기 전까지 진행하지 않음.
* 트리거가 onNext 로 진행하면 그때부터 진행 (작동).


### 3.8.3 SkipWhile
```swift
Observable.from(numbers)
    .skip(while: {
        $0 % 2 == 0
    })
    .subscribe {
        print("SkipWhile #1", $0)
    }
    .disposed(by: disposeBag)
```
* 1, 2, 3, 4, ... 10, completed

```swift
Observable.from(numbers)
    .skip(while: {
        $0 < 5 || $0 == 8
    })
    .subscribe {
        print("SkipWhile #2", $0)
    }
    .disposed(by: disposeBag)
```
* 5, 6, 7, 9, 10 completed 가 아닌
* 5, 6, 7, 8, 9, 10 completed.
* 조건이 false 가 되면 정상 작동.
* 조건이 true 이면 그 값을 무시함.
* 그러나 조건이 false 이고 그 뒤에 true 가 나와도 그냥 방출함.


##  3.9 Take, TakeLast, TakeUntil
### 3.9.1 Take
```swift
Observable.from(numbers)
    .take(5)
    .subscribe {
        print("Take #1", $0)
    }
    .disposed(by: disposeBag)
```
* 0, 1, 2, 3, 4, completed
* count 만큼 첫번째 값부터 방출함.

###  3.9.2 TakeLast
```swift
Observable.from(numbers)
    .takeLast(4)
    .subscribe {
        print("TakeLast #1", $0)
    }
    .disposed(by: disposeBag)
```
* 7, 8, 9, 10, completed
* 마지막 count 만큼의 값을 가지고 있다가 onCompleted 되면 방출함

###  3.9.3 TakeUntil
```swift
let takeUntilSubject = PublishSubject<Int>()
let takeUntilTrigger = PublishSubject<Int>()

takeUntilSubject.take(until: takeUntilTrigger)
    .subscribe {
        print("TakeUntil #1", $0)
    }
    .disposed(by: disposeBag)

takeUntilSubject.onNext(0)
takeUntilSubject.onNext(1)
takeUntilSubject.onNext(2)

takeUntilTrigger.onNext(0)

```
* 0, 1, 2, completed
* Trigger가 Next를 하기 전까지 값을 방출함.
* Trigger 가 값을 방출하면 takeUntilSubject 는 completed 된다.
