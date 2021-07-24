import UIKit
import RxSwift

enum RxE: Error {
    case error
}

var disposeBag = DisposeBag()

let sourceSubject = PublishSubject<Int>()
let anotherSubject = PublishSubject<Int>()

sourceSubject
    .catch { _ in anotherSubject }
    .subscribe { print($0) }
    .disposed(by: disposeBag)

sourceSubject.onNext(1)
// 1
sourceSubject.onError(RxE.error)

sourceSubject.onNext(2)

anotherSubject.onNext(3)
// 3
anotherSubject.onCompleted()
// completed
// catch 는 말 그대로 error를 catch 함.
// error를 catch 하면 다른 Observable 을 할당함.


let catchAndReturn = PublishSubject<String>()

catchAndReturn
    .catchAndReturn("Error 입니다.")
    .subscribe { print($0) }
    .disposed(by: disposeBag)

catchAndReturn.onNext("A")
// A
catchAndReturn.onError(RxE.error)
// Error 입니다., completed
// catchAndReturn 은 error 를 catch 하면 Element를 return 함.


var retryCounting = 0

let retryObservable = Observable<String>.create { observer in
    print("retryCounting:", retryCounting)
    if retryCounting < 5 {
        observer.onError(RxE.error)
        retryCounting += 1
    }
    observer.onNext("Finish Retry")
    observer.onCompleted()
    
    return Disposables.create ()
}

retryObservable
    .retry(6)
    .subscribe { print($0) }
    .disposed(by: disposeBag)
// 6번 실행되면서 종료.
// retry 는 말 그대로 횟수만큼 재시도함.


retryCounting = 0

let retryWhenObservable = Observable<String>.create { observer in
    print("retryWhenCounting:", retryCounting)
    
    if retryCounting < 5 {
        observer.onError(RxE.error)
        retryCounting += 1
    }
    observer.onNext("Finish retryWhen")
    observer.onCompleted()
    
    return Disposables.create ()
}

let retryWhenTrigger = PublishSubject<String>()

retryWhenObservable
    .retry(when: { _ in retryWhenTrigger })
    .subscribe { print($0) }
    .disposed(by: disposeBag)

retryWhenTrigger.onNext("A")
retryWhenTrigger.onNext("A")
retryWhenTrigger.onNext("A")
retryWhenTrigger.onNext("A")
retryWhenTrigger.onNext("A")
// 0, 1, 2, 3, 4, 5, Finish retryWhen
// retryWhen 은 trigger 를 받아서 trigger에 Next 될 때 재시도함.
