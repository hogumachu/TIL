//
//  FriendsTableViewController.swift
//  TodayILearned
//
//  Created by 홍성준 on 2021/07/25.
//

import UIKit
import RxSwift
import RxCocoa

class FriendsTableViewController: UIViewController {
    let friendTableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    var disposeBag = DisposeBag()
    let friendObservable = Observable.of(myFriends)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(friendTableView)
        friendTableView.translatesAutoresizingMaskIntoConstraints = false
        friendTableView.register(FriendsTableViewCell.self, forCellReuseIdentifier: "friendCell")
        NSLayoutConstraint.activate([
            friendTableView.topAnchor.constraint(equalTo: view.topAnchor),
            friendTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            friendTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            friendTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        friendObservable.bind(to: friendTableView.rx.items(cellIdentifier: "friendCell", cellType: FriendsTableViewCell.self)) { row, element, cell in
            cell.nameLabel.text = element.name
            cell.ageLabel.text = "\(element.age)"
            cell.emailLabel.text = element.email
        }
        .disposed(by: disposeBag)
        
    }
}
