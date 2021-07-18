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
