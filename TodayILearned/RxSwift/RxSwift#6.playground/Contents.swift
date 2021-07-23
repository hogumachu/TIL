import UIKit
import RxSwift

var disposeBag = DisposeBag()


// CombineLatest

let leftSource = PublishSubject<Int>()
let rightSource = PublishSubject<Int>()

Observable.combineLatest(leftSource, rightSource)
    .subscribe {
        if let (left, right) = $0.element {
            print(left, right)
        } else {
            print($0)
        }
    }.disposed(by: disposeBag)

leftSource.onNext(0)
rightSource.onNext(0)
// 0 0
leftSource.onNext(1)
// 1 0
leftSource.onNext(2)
// 2 0
rightSource.onNext(100)
// 2 100
rightSource.onCompleted()

leftSource.onNext(10)
// 10 100
leftSource.onCompleted()
// completed
// combineLatest 는 observable 의 가장 마지막 값들을 하나로 묶어 방출함.
// 하나가 completed 되어도 그 하나의 마지막 값을 알기에 모든 observable이 completed 되기 전까지 종료되지 않음. (error는 하나라도 있을 경우 바로 종료)



// Merge

let alphabetSubject = PublishSubject<String>()
let hangulSubject = PublishSubject<String>()
let numberSubject = PublishSubject<String>()

Observable.of(alphabetSubject, hangulSubject, numberSubject)
    .merge()
    .subscribe { print($0) }
    .disposed(by: disposeBag)

alphabetSubject.onNext("A")
// A
hangulSubject.onNext("ㅁ")
// ㅁ
numberSubject.onNext("1")
// 1
alphabetSubject.onNext("B")
// B
alphabetSubject.onCompleted()
alphabetSubject.onNext("C")
hangulSubject.onCompleted()
numberSubject.onCompleted()
// completed

let justA = PublishSubject<String>()
let justB = PublishSubject<String>()
let justC = PublishSubject<String>()

Observable.of(justA, justB, justC)
    .merge(maxConcurrent: 2)
    .subscribe { print($0) }
    .disposed(by: disposeBag)

justA.onNext("A")
// A
justC.onNext("C")

justB.onNext("B")
// B
justA.onNext("a")
// a
justB.onCompleted()

justC.onNext("c")
// c
// Merge 는 Observable 의 값들이 들어온 순서대로 방출함.
// maxConcurrent 값을 설정하게 되면 Observable은 최대 maxConcurrent 의 변화만 subcribe하고 만약 그 중 하나의 observable 이 completed 되면 그 뒤에 대기중인 observable 을 다시 subscribe함.


// StatWith

Observable.from([5, 6])
    .startWith(3, 4)
    .startWith(1, 2)
    .subscribe { print($0) }
    .disposed(by: disposeBag)
// 1, 2, 3, 4, 5, 6, completed
// 기존의 값 앞으로 값을 추가함.


// SwitchLatest

let switchLatestSubject = PublishSubject<PublishSubject<Int>>()
let plusNum = PublishSubject<Int>()
let minusNum = PublishSubject<Int>()

switchLatestSubject.switchLatest()
    .subscribe { print($0) }
    .disposed(by: disposeBag)

switchLatestSubject.onNext(plusNum)

plusNum.onNext(1)
// 1
plusNum.onNext(2)

switchLatestSubject.onNext(minusNum)
plusNum.onNext(3)

minusNum.onNext(-1)
// -1
switchLatestSubject.onNext(plusNum)
minusNum.onNext(-2)

plusNum.onNext(4)
// 4
plusNum.onCompleted()

switchLatestSubject.onCompleted()
// completed
// switchLatest 는 자신이 onNext 로 받은 최신 Observable 이 방출하는 값을 받음
// completed 에는 반응하지 않지만 error 를 받을 경우 종료함.


// Zip

let leftZip = PublishSubject<Int>()
let rightZip = PublishSubject<Int>()

Observable.zip(leftZip, rightZip)
    .subscribe {
        if let (left, right) = $0.element {
            print(left, right)
        } else {
            print($0)
        }
    }.disposed(by: disposeBag)

leftZip.onNext(0)
rightZip.onNext(0)
// 0 0
leftZip.onNext(1)
leftZip.onNext(2)
leftZip.onNext(3)

rightZip.onNext(1)
// 1 1
leftZip.onCompleted()

rightZip.onNext(2)
// 2 2
rightZip.onNext(3)
// 3 3
rightZip.onCompleted()
// completed

// Zip은 Observable을 받아 방출하는 값들을 하나로 묶어서 방출함
// combineLatest 와 다른 점은 Zip은 index 에 맞는 값들만 방출함. (중복된 방출 X)
// 하나가 completed 되어도 값이 남아 있다면 다른 observable 에 값이 방출되면 index 에 짝이 맞다면 값이 방출된다.
