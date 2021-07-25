//
//  ViewController.swift
//  TodayILearned
//
//  Created by 홍성준 on 2021/07/16.
//

import UIKit

class ViewController: UIViewController {
    
    let autoLayoutButton: UIButton = {
        let uiButton = UIButton()
        uiButton.setTitle("AutoLayout", for: .normal)
        uiButton.setTitleColor(.systemPink, for: .normal)
        uiButton.addTarget(self, action: #selector(gotoAutoLayoutViewController), for: .touchUpInside)
        return uiButton
    }()
    
    let tableViewButton: UIButton = {
        let uiButton = UIButton()
        uiButton.setTitle("tableView", for: .normal)
        uiButton.setTitleColor(.systemPink, for: .normal)
        uiButton.addTarget(self, action: #selector(gotoFriendsTableViewController), for: .touchUpInside)
        return uiButton
    }()
    
    @objc func gotoAutoLayoutViewController(sender: UIButton) {
        let AutolayoutViewController = MyProfileViewController()
        AutolayoutViewController.modalPresentationStyle = .fullScreen
        self.present(AutolayoutViewController, animated: true, completion: nil)
    }
    
    @objc func gotoFriendsTableViewController(sender: UIButton) {
        let tableVC = FriendsTableViewController()
        tableVC.modalPresentationStyle = .fullScreen
        self.present(tableVC, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        view.addSubview(autoLayoutButton)
        view.addSubview(tableViewButton)
        
        autoLayoutButton.translatesAutoresizingMaskIntoConstraints = false
        tableViewButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            autoLayoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            autoLayoutButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            tableViewButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tableViewButton.topAnchor.constraint(equalTo: autoLayoutButton.bottomAnchor, constant: 10)
        ])
    }
}

