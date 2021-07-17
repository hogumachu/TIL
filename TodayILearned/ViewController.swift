//
//  ViewController.swift
//  TodayILearned
//
//  Created by 홍성준 on 2021/07/16.
//

import UIKit

class ViewController: UIViewController {
    
    let autoLayoutButton = UIButton()
    
    @objc func gotoAutoLayoutViewController(sender: UIButton) {
        let AutolayoutViewController = AutolayoutViewController()
        AutolayoutViewController.modalPresentationStyle = .fullScreen
        self.present(AutolayoutViewController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        autoLayoutButton.setTitle("AutoLayout", for: .normal)
        autoLayoutButton.setTitleColor(.systemPink, for: .normal)
        autoLayoutButton.addTarget(self, action: #selector(gotoAutoLayoutViewController), for: .touchUpInside)
        
        view.addSubview(autoLayoutButton)
        
        
        autoLayoutButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            autoLayoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            autoLayoutButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
}

