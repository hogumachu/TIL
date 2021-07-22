import UIKit
import RxSwift
import RxCocoa

var disposeBag = DisposeBag()
let numbers = [0, 1, 2, 3, 4, 5,6 ,7 ,8, 9, 10]

// Debounce
// 시간 안에 Next 된 값 중에서 가장 최신 값을 방출
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

debounceObserver
    .debounce(.seconds(1), scheduler: MainScheduler.instance)
    .subscribe { print("Debounce #1", $0) }
    .disposed(by: disposeBag)
// 10, completed

debounceObserver
    .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
    .subscribe { print("Debounce #2", $0) }
    .disposed(by: disposeBag)
// 0, 1, ..., 10, completed



// Distinct
// 중복된 값 (자신 바로 앞에 있는 값) 을 제거한 항목을 배출함
Observable.from(numbers)
    .distinctUntilChanged()
    .subscribe { print("Distint #1", $0) }
    .disposed(by: disposeBag)
// 0, 1, ..., 10, completed

Observable.from([1, 1, 1, 2, 2, 3, 2, 3, 3, 2, 2])
    .distinctUntilChanged()
    .subscribe { print("Distint #2", $0) }
    .disposed(by: disposeBag)
// 1, 2, 3, 2, 3, 2 completed


// ElementAt
// 해당 index에 있는 값을 배출
// index 값이 넘어가면 error
Observable.from(numbers)
    .element(at: 3)
    .subscribe { print("ElementAt #1", $0)}
    .disposed(by: disposeBag)
// 3, completed

// Filter
// 말 그대로 조건이 true 인 값을 배출
Observable.from(numbers)
    .filter { $0 % 2 == 0 }
    .subscribe {
        print("Filter #1", $0)
    }
    .disposed(by: disposeBag)
// 0, 2, 4, 6, 8, 10, completed


// First (Single)
// 한 개의 값만 방출되어야 함.
Observable.from(numbers)
    .single()
    .subscribe {
        print("First #1", $0)
    }
    .disposed(by: disposeBag)
// 0이 배출되고 completed가 아닌 error 발생
// numbers에 값이 1개를 넘기 때문

Observable.from(numbers)
    .single{
        $0 == 5
    }
    .subscribe {
        print("First #2", $0)
    }
    .disposed(by: disposeBag)
// 5가 배출되고 completed
// 값이 5인 것이 하나 밖에 없어서 정상적으로 진행


// IgnoreElements
// completed 인지 error 인지만 알려주고 나머지 요소는 무시함
Observable.from(numbers)
    .ignoreElements()
    .subscribe {
        print("IgnoreElements #1", $0)
    }
    .disposed(by: disposeBag)


// Last (X)

// Sample
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

// Subject 가 먼저 onNext 되고 그 뒤로 Trigger가 onNext 되면 Subject 의 최신 값이 onNext 된다.
// 위의 예시는 Trigger 1, Subject 1 순서로 되어서 아직 방출 되지 않고
// Trigger 2가 되는 순간 Subject의 1이 방출
// 그 후 Trigger에 2를 줘도 아무 변화. 없고
// Subject에 2를 주고
// 그 뒤로 Trigger에 3을 주니 Subject의 2가 방출되었음.
// Completed 도 동일한 방식으로 진행.


// Skip
// Count 만큼 값을 skip.
Observable.from(numbers)
    .skip(3)
    .subscribe {
        print("Skip #1", $0)
    }
    .disposed(by: disposeBag)
// 3, 4, 5, 6, 7, 8, 9, 10, completed

Observable.from(numbers)
    .skip(100)
    .subscribe {
        print("Skip #2", $0)
    }
    .disposed(by: disposeBag)
// skip count가 index의 크기를 넘어가도 error 나지 않고 completed.



// SkipUntil
// 트리거가 진행하기 전까지 진행하지 않음
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
// Trigger가 onNext 가 되고 나면 그때부터 작동함.


// SkipWhile
// 조건이 false 가 되면 정상 작동
// 조건이 true 이면 그 값은 무시함
// 그 후 조건이 false 가 되고 그 뒤에 조건이 true라도 그냥 방출
Observable.from(numbers)
    .skip(while: {
        $0 % 2 == 0
    })
    .subscribe {
        print("SkipWhile #1", $0)
    }
    .disposed(by: disposeBag)
// 1, 2, 3, 4, ... 10, completed
Observable.from(numbers)
    .skip(while: {
        $0 < 5 || $0 == 8
    })
    .subscribe {
        print("SkipWhile #2", $0)
    }
    .disposed(by: disposeBag)
// 5, 6, 7, 9, 10 completed 가 아닌
// 5, 6, 7, 8, 9, 10 completed.


// Take
// count 만큼 첫번째 값부터 방출함.
Observable.from(numbers)
    .take(5)
    .subscribe {
        print("Take #1", $0)
    }
    .disposed(by: disposeBag)
// 0, 1, 2, 3, 4, completed


// TakeLast
// 마지막 count 만큼의 값을 가지고 있다가 onCompleted 되면 방출함
Observable.from(numbers)
    .takeLast(4)
    .subscribe {
        print("TakeLast #1", $0)
    }
    .disposed(by: disposeBag)


// TakeUntil
// Trigger가 Next를 하기 전까지 값을 방출함.

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
// Trigger 가 값을 방출하면 takeUntilSubject 는 completed 된다.
