import UIKit
import RxSwift

var disposeBag = DisposeBag()
let numbers = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10]


Observable.from(numbers)
    .buffer(timeSpan: .seconds(10), count: 3, scheduler: MainScheduler.instance)
    .subscribe { print($0) }
    .disposed(by: disposeBag)
// [0, 1, 2], [3, 4, 5], [6, 7, 8], [9, 10], completed

Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
    .buffer(timeSpan: .seconds(3), count: 2, scheduler: MainScheduler.instance)
    .take(3)
    .subscribe { print($0) }
    .disposed(by: disposeBag)
// [0, 1], [2, 3], [4, 5], completed
// buffer timeSpan 동안 최대 count 만큼의 값을 받고 방출함.


let subject = PublishSubject<BehaviorSubject<String>>()
subject.flatMap { $0.asObserver() }
    .subscribe { print("FlatMap #1", $0) }
    .disposed(by: disposeBag)

let behaviorSubjectA = BehaviorSubject<String>(value: "A")
let behaviorSubjectB = BehaviorSubject<String>(value: "B")

subject.onNext(behaviorSubjectA)
// FlatMap #1 next(A)
subject.onNext(behaviorSubjectB)
// FlatMap #1 next(B)
behaviorSubjectA.onNext("AA")
// FlatMap #1 next(AA)
behaviorSubjectB.onNext("BB")
// FlatMap #1 next(BB)
behaviorSubjectA.onNext("AAA")
// FlatMap #1 next(AAA)


// flatMap 은 Observable 을 return 함.
// 하나의 observable 에서 발생시키는 항목을 여러 개의 Observable 로 변환하고 항목의 방출 순서대로 묶어 하나의 observalbe 로 전달


let names = ["Ho", "gu", "ma", "chu", "Hog", "uma", "chu!"]

Observable.from(names)
    .groupBy { $0.count }
    .subscribe {
        print("OuterObservable", $0)
        if let observable = $0.element {
            observable.subscribe { print("InnerObservable", $0) }
        }
    }
    .disposed(by: disposeBag)
// groupBy 는 Hashable 한 조건을 줘야함. 그 조건 (Key 값) 으로 묶고 Observable 을 Return 함.
// 먼저 key 값이 2인 outer가 출력되고 그 뒤로 "Ho", "gu", "ma" 가 출력
// 다음으로 key 값이 3인 outer가 출력되고 그 뒤로 "chu", "Hog", "uma" 출력
// 마지막으로 key 값이 4인 outer가 출력되고 그 뒤로 "chu!" 출력
// 각각 InnerObservable 이 completed 되고 마지막에 OuterObservable 이 completed



Observable.from(numbers)
    .map { $0 + 1 }
    .subscribe { print("Map #1", $0)}
    .disposed(by: disposeBag)
// 하나하나 값을 Mapping 함
// 1, 2, 3, 4, 5, ... ,10, 11, completed

numbers
    .map { $0 + 1 }
    .forEach { print("Another Map #1", $0) }
// 기존에 사용하는 map 과 크게 다를 바 없는 듯.


Observable.from(numbers)
    .scan(0, accumulator: +)
    .subscribe { print("Scan #1", $0)}
    .disposed(by: disposeBag)

print( "Reduce", numbers.reduce(0, +) )
    
// Reduce 는 계산된 최종 결과를 보여주지만
// Observable의 scan 은 그 계산 과정을 하나하나 방출함
// 0, 1, 3, 6, ... , 45, 55, completed


Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
    .window(timeSpan: .seconds(2), count: 5, scheduler: MainScheduler.instance)
    .take(3)
    .subscribe { print("Window Outer #1", $0)
        if let observable = $0.element {
            observable.subscribe { print("Window Inner #1", $0) }
        }
    }
    .disposed(by: disposeBag)
// buffer 와 비슷하나 butter는 Observable 이 아닌 배열로 방출하고
// Window 는 Observable로 방출함
