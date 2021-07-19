import UIKit
import RxSwift
import RxCocoa

var disposeBag = DisposeBag()
let firstNumbers = [1, 2, 3, 4, 5, 6]
let secondNumbers = [1, 2, 3]
let thirdNumbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
let StringArray = ["a", "b", "c"]

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

let str = "Hogumachu"

Observable
    .generate(
        initialState: str,
        condition: { $0.count < 13 },
        iterate: { $0 + "!" })
    .subscribe {
        print("Generate", $0)
    }
// initialState 로 시작해서 condition의 조건까지 iterate에 있는 조건으로 반복함.
// Hoguamchu, Hogumachu!, Hogumachu!!, Hogumachu!!! 이렇게 $0.count가 12가 되고 종료.



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
// Observer 가 Subscribe 하기 전까지 Observable 생성을 지연
// Subscribe가 시작 되면 Observer 별로 새로운 Observable 생성


Observable<Any>.empty()
    .subscribe {
        print($0)
    }
    .disposed(by: disposeBag)

// Empty 는 아무 것도 emit 하지 않고 일반적으로 끝남 (completed 만 하고 끝남).

//Observable<Any>.never()
//    .subscribe {
//        print($0)
//    }
//    .disposed(by: disposeBag)

// Never 는 아무 것도 emit 하지 않고 그리고 끝나지 않음. (No completed, No error)

enum error: Error {
    case error
}

Observable.error(error.error)
    .subscribe {
        print($0)
    }
    .disposed(by: disposeBag)
// 공식 문서에서 Throw를 failWith 라고 했는데 error로 바뀌었음.
// 아무 것도 emit 하지 않고 error 한번 호출하고 끝남.


Observable
    .from(firstNumbers)
    .subscribe {
        print($0)
    }
    .disposed(by: disposeBag)
// 1.3 에서 소개한 바 있음.
// from 은 배열을 받고 배열 안에 있는 Element 로 나옴.

//Observable
//    .from(firstNumbers, secondNumbers)
//    .subscribe {
//        print($0)
//    }
//    .disposed(by: disposeBag)
//여러 개의 파라미터를 받는 것은 불가능.


Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
    .subscribe {
        print("Interval", $0)
    }
    .disposed(by: disposeBag)

DispatchQueue.global().asyncAfter(deadline: .now() + 10, execute: {
    disposeBag = DisposeBag()
})

// 1.3 에서 소개한 바 있음.


Observable
    .just(firstNumbers)
    .subscribe{
        print("Just", $0)
    }
    .disposed(by: disposeBag)
// just로 받은 값은 그대로 값이 나옴
// 배열이 들어가면 배열 안의 Element 를 하나 하나 받는 것이 아닌 배열 자체로 나옴.
// next([1, 2, 3, 4, 5, 6]), completed

Observable
    .range(start: 0, count: 3)
    .subscribe {
        print("Range",$0)
    }
    .disposed(by: disposeBag)
// start 부터 시작해서 1씩 증가하여 총 count 번 출력함 (0, 1, 2)

//Observable
//    .repeatElement("Hogumachu")
//    .subscribe {
//        print($0)
//    }
// 무한 반복함

Observable
    .repeatElement("Hogumachu")
    .take(3)
    .subscribe {
        print("RepeatElement", $0)
    }
    .disposed(by: disposeBag)
// take 와 함께 사용하자



Observable
    .of(firstNumbers, secondNumbers, thirdNumbers)
    .subscribe{
        print("Of", $0)
    }
    .disposed(by: disposeBag)
// of 는 여러 개의 파라미터를 받을 수 있음.
// 파라미터로 받은 값은 파라미터 안의 Element로 나오는 것이 아닌 just 처럼 파라미터 단위 통째로 나옴.
// next([1, 2, 3, 4, 5, 6]), next([1, 2, 3]), next([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]), completed



//Observable
//    .of(firstNumbers, StringArray)
//    .subscribe{
//        print($0)
//    }
//    .disposed(by: disposeBag)
// 파라미터의 type 은 동일해야 함. (위 코드는 에러)




Observable
    .of(firstNumbers, secondNumbers, thirdNumbers)
    .subscribe { ofData in
        if let array = ofData.element {
            array.forEach { element in
                print(ofData, "Element:", element)
            }
        } else {
            print(ofData)
        }
    }
// 여러 개의 파라미터와 그 안에 있는 Element를 받으려면
// 이런 식으로 해야할 듯.











