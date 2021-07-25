RxSwift
==========
# 8. TableView (Init)

```swift
class FriendsTableViewController: UIViewController {

let friendTableView: UITableView = {
    let tableView = UITableView()
    return tableView
}()

var disposeBag = DisposeBag()

let friendObservable = Observable.of(myFriends)
// 중략
}
```

```swift
struct Friend {
    let name: String
    let age: Int
    let email: String
}

let myFriends = [
    Friend(name: "김호구마츄", age: 25, email: "kimhogu@gmail.com"),
    Friend(name: "박호구마츄", age: 21, email: "parkhogu@gmail.com"),
    Friend(name: "정호구마츄", age: 23, email: "junghogu@gmail.com"),
    Friend(name: "최호구마츄", age: 21, email: "choihogu@gmail.com"),
    Friend(name: "홍호구마츄", age: 27, email: "honghogu@gmail.com"),
]

```
* 먼저 `tableView` 를 생성하고 `data` 를 `Observable` 할 `friendObservable` 을 생성함.


```swift

class FriendsTableViewController: UIViewController {
    // 중략
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(friendTableView)
        
        // 중략
        
        friendTableView.register(FriendsTableViewCell.self, forCellReuseIdentifier: "friendCell")
        friendObservable.bind(to: friendTableView.rx.items(cellIdentifier: "friendCell", cellType: FriendsTableViewCell.self)) { row, element, cell in
            cell.nameLabel.text = element.name
            cell.ageLabel.text = "\(element.age)"
            cell.emailLabel.text = element.email
        }
        .disposed(by: disposeBag)
    }
}

```
* `friendTableView` 에 먼저 `FriendsTableViewCell` 을 등록함.
* `friendObservable` 에 `friendTableView`의 `items` 을 묶음.
* `cell` 에 각각 `Data` 를 입력해줌.

<img src = "https://user-images.githubusercontent.com/74225754/126899487-c738a7bf-06ad-436b-a7f2-5e8614d6dfdf.png" width="30%" height="30%">
