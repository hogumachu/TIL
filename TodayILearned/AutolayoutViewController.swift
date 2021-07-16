//
//  AutolayoutViewController.swift
//  TodayILearned
//
//  Created by 홍성준 on 2021/07/16.
//

import UIKit

class AutolayoutViewController: UIViewController {
    let closeButton = UIButton()
    let topView = UIView()
    let bottomView = UIView()
    let profileImageView = UIImageView()
    let backgroundImageView = UIImageView()
    let nameLabel = UILabel()
    let statusLabel = UILabel()
    let horizontalStackView = UIStackView()
    let chatView = UIView()
    let editView = UIView()
    let storyView = UIView()
    let chatImageView = UIImageView()
    let chatLabel = UILabel()
    let editImageView = UIImageView()
    let editLabel = UILabel()
    let storyImageView = UIImageView()
    let storyLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        draw()
        
        profileImageView.layer.cornerRadius = 20
    }
    
    
    func draw() {
        view.addSubViews(UIViews: [
            backgroundImageView,
            bottomView.addSubViewAndReturnSelf(UIView:
                                                horizontalStackView.addSubViewsAndReturnSelf(UIViews: [
                                                    chatView.addSubViewsAndReturnSelf(UIViews: [
                                                        chatImageView,
                                                        chatLabel
                                                    ]),
                                                    editView.addSubViewsAndReturnSelf(UIViews: [
                                                        editImageView,
                                                        editLabel
                                                    ]),
                                                    storyView.addSubViewsAndReturnSelf(UIViews: [
                                                        storyImageView,
                                                        storyLabel
                                                    ])
                                                ])),
            topView.addSubViewsAndReturnSelf(UIViews: [
                closeButton,
                profileImageView,
                nameLabel,
                statusLabel,
            ]),
        ])
        
        translatesAutoresizingMaskIntoConstraints(UIViews: [backgroundImageView, bottomView, topView, chatImageView, closeButton, profileImageView, nameLabel, statusLabel, horizontalStackView, chatView, editView, storyView, chatLabel, editImageView, editLabel, storyImageView, storyLabel])
        
        backgroundImageView.backgroundColor = .systemGray
        
        bottomView.layer.borderWidth = 1
        bottomView.layer.borderColor = UIColor.white.cgColor
        
        closeButton.setImage(UIImage(named: "close"), for: .normal)
        
        profileImageView.image = UIImage(named: "profile")
        profileImageView.backgroundColor = .systemPink
        profileImageView.clipsToBounds = true
        
        nameLabel.text = "Hogumachu"
        nameLabel.textColor = .white
        nameLabel.textAlignment = .center
        nameLabel.font = UIFont.boldSystemFont(ofSize: 18)
        nameLabel.textAlignment = .center
        
        statusLabel.text = "Nice To Meet You"
        statusLabel.textColor = .white
        statusLabel.textAlignment = .center
        
        horizontalStackView.axis = .horizontal
        horizontalStackView.distribution = .fillEqually
        horizontalStackView.alignment = .fill
        horizontalStackView.contentMode = .scaleToFill
        
        chatImageView.image = UIImage(named: "chat")
        chatImageView.contentMode = .scaleAspectFit
        
        chatLabel.text = "나와의 채팅"
        chatLabel.textColor = .white
        chatLabel.textAlignment = .center
        
        editImageView.image = UIImage(named: "edit")
        editImageView.contentMode = .scaleAspectFit
        
        editLabel.text = "프로필 편집"
        editLabel.textColor = .white
        editLabel.textAlignment = .center
        
        storyImageView.image = UIImage(named: "insta")
        storyImageView.contentMode = .scaleAspectFit
        
        storyLabel.text = "인스타그램"
        storyLabel.textColor = .white
        storyLabel.textAlignment = .center
        
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -1),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 1),
            bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 1),
            bottomView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.15),
            
            topView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topView.bottomAnchor.constraint(equalTo: bottomView.topAnchor),
    
            statusLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            statusLabel.bottomAnchor.constraint(equalTo: statusLabel.superview!.bottomAnchor, constant: -30),
            
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: statusLabel.topAnchor, constant: -10),
            
            closeButton.topAnchor.constraint(equalTo: closeButton.superview!.topAnchor, constant: 10),
            closeButton.leadingAnchor.constraint(equalTo: closeButton.superview!.leadingAnchor, constant: 30),
            closeButton.widthAnchor.constraint(equalToConstant: 20),
            closeButton.heightAnchor.constraint(equalToConstant: 20),
            
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.bottomAnchor.constraint(equalTo: nameLabel.topAnchor, constant: -10),
            profileImageView.heightAnchor.constraint(equalToConstant: 120),
            profileImageView.widthAnchor.constraint(equalToConstant: 120),
            
            horizontalStackView.centerXAnchor.constraint(equalTo: horizontalStackView.superview!.centerXAnchor),
            horizontalStackView.centerYAnchor.constraint(equalTo: horizontalStackView.superview!.centerYAnchor),
            horizontalStackView.heightAnchor.constraint(equalTo: horizontalStackView.superview!.heightAnchor, multiplier: 1 / 3),
            horizontalStackView.widthAnchor.constraint(equalTo: horizontalStackView.superview!.widthAnchor, multiplier: 4 / 5),
            
            chatView.topAnchor.constraint(equalTo: chatView.superview!.topAnchor),
            chatView.leadingAnchor.constraint(equalTo: chatView.superview!.leadingAnchor),
            chatView.widthAnchor.constraint(equalTo: chatView.superview!.widthAnchor, multiplier: 1 / 3),
            chatView.bottomAnchor.constraint(equalTo: chatView.superview!.bottomAnchor),
            
            editView.topAnchor.constraint(equalTo: editView.superview!.topAnchor),
            editView.leadingAnchor.constraint(equalTo: chatView.trailingAnchor),
            editView.widthAnchor.constraint(equalTo: chatView.widthAnchor),
            editView.bottomAnchor.constraint(equalTo: editView.superview!.bottomAnchor),
            
            storyView.topAnchor.constraint(equalTo: storyView.superview!.topAnchor),
            storyView.leadingAnchor.constraint(equalTo: editView.trailingAnchor),
            storyView.widthAnchor.constraint(equalTo: chatView.widthAnchor),
            storyView.bottomAnchor.constraint(equalTo: storyView.superview!.bottomAnchor),
            
            chatImageView.topAnchor.constraint(equalTo: chatImageView.superview!.topAnchor),
            chatImageView.leadingAnchor.constraint(equalTo: chatImageView.superview!.leadingAnchor),
            chatImageView.trailingAnchor.constraint(equalTo: chatImageView.superview!.trailingAnchor),
//            chatImageView.heightAnchor.constraint(equalTo: chatImageView.superview!.heightAnchor, multiplier: 2 / 3),
            chatImageView.bottomAnchor.constraint(equalTo: chatLabel.layoutMarginsGuide.topAnchor, constant: -10),
            
            chatLabel.leadingAnchor.constraint(equalTo: chatLabel.superview!.leadingAnchor),
            chatLabel.trailingAnchor.constraint(equalTo: chatLabel.superview!.trailingAnchor),
            chatLabel.bottomAnchor.constraint(equalTo: chatLabel.superview!.bottomAnchor),
//            chatLabel.heightAnchor.constraint(equalTo: chatLabel.superview!.heightAnchor, multiplier: 1 / 3),
            
            editImageView.topAnchor.constraint(equalTo: editImageView.superview!.topAnchor),
            editImageView.leadingAnchor.constraint(equalTo: editImageView.superview!.leadingAnchor),
            editImageView.trailingAnchor.constraint(equalTo: editImageView.superview!.trailingAnchor),
            editImageView.heightAnchor.constraint(equalTo: editImageView.superview!.heightAnchor, multiplier: 2 / 3),
            
            editLabel.leadingAnchor.constraint(equalTo: editLabel.superview!.leadingAnchor),
            editLabel.trailingAnchor.constraint(equalTo: editLabel.superview!.trailingAnchor),
            editLabel.bottomAnchor.constraint(equalTo: editLabel.superview!.bottomAnchor),
            editLabel.heightAnchor.constraint(equalTo: editLabel.superview!.heightAnchor, multiplier: 1 / 3),
            
            storyImageView.topAnchor.constraint(equalTo: storyImageView.superview!.topAnchor),
            storyImageView.leadingAnchor.constraint(equalTo: storyImageView.superview!.leadingAnchor),
            storyImageView.trailingAnchor.constraint(equalTo: storyImageView.superview!.trailingAnchor),
            storyImageView.heightAnchor.constraint(equalTo: storyImageView.superview!.heightAnchor, multiplier: 2 / 3),
            
            storyLabel.leadingAnchor.constraint(equalTo: storyLabel.superview!.leadingAnchor),
            storyLabel.trailingAnchor.constraint(equalTo: storyLabel.superview!.trailingAnchor),
            storyLabel.bottomAnchor.constraint(equalTo: storyLabel.superview!.bottomAnchor),
            storyLabel.heightAnchor.constraint(equalTo: storyLabel.superview!.heightAnchor, multiplier: 1 / 3),
            
            
        ])
        
        if #available(iOS 11.0, *) {
            topView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        } else {
            topView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        }
        
    }
}


func translatesAutoresizingMaskIntoConstraints(UIViews: [UIView]) {
    UIViews.forEach({ UIView in
        UIView.translatesAutoresizingMaskIntoConstraints = false
    })
}

extension UIView {
    func addSubViews(UIViews: [UIView]) {
        UIViews.forEach({ UIView in
            self.addSubview(UIView)
        })
    }
    
    func addSubViewsAndReturnSelf(UIViews: [UIView]) -> UIView {
        UIViews.forEach({ UIView in
            self.addSubview(UIView)
        })
        return self
    }
    
    func addSubViewAndReturnSelf(UIView: UIView) -> UIView {
        self.addSubview(UIView)
        return self
    }
}
