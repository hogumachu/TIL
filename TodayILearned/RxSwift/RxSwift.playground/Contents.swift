import UIKit
import RxSwift

Observable.from(["H", "O", "G", "U", "M", "A", "C", "H", "U"])
    .subscribe {
        print($0)
    }
// next(H), next(O) ... next(U), completed 이런 식으로 끝남

Observable.from(["H", "O", "G", "U", "M", "A", "C", "H", "U"])
    .subscribe {
        print($0.element)
    }
// $0.element로 값에 접근 가능 (Optional 값)
// Optional("H"), ... Optional("U"), nil
// nil 값이 나오는 것으로 보아 마지막에 Completed 가 오는 것 같음

Observable.from(["H", "O", "G", "U", "M", "A", "C", "H", "U"])
    .subscribe {
        if let data = $0.element {
            print(data)
        } else {
            print("Not String")
            print($0)
        }
    }
// H, O ... , H, U, Not String, completed
// 예상대로 마지막 값은 completed 였음
// 만약 마지막이 Error 였으면 Error 가 나옴.

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
