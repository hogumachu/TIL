import UIKit
import RxSwift
import RxCocoa

enum error: Error {
    case subjectError
}
var disposeBag = DisposeBag()
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

print()



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

// Publish Subject와 다른 점은 Behavior는 초기 값을 받음.

print()

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

print()

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

print()

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

// Subject와 다른 점: onCompleted, onError 가 불가능, onNext 가 아닌 accept로 값을 받음.
