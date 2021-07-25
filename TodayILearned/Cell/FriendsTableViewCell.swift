//
//  FriendsTableViewCell.swift
//  TodayILearned
//
//  Created by 홍성준 on 2021/07/25.
//

import UIKit

class FriendsTableViewCell: UITableViewCell {
    let nameLabel: UILabel = {
        let uiLabel = UILabel()
        uiLabel.textColor = .black
        uiLabel.font = .systemFont(ofSize: 15)
        uiLabel.textAlignment = .left
        return uiLabel
    }()
    let ageLabel: UILabel = {
        let uiLabel = UILabel()
        uiLabel.textColor = .black
        uiLabel.font = .systemFont(ofSize: 15)
        uiLabel.textAlignment = .left
        return uiLabel
    }()
    let emailLabel: UILabel = {
        let uiLabel = UILabel()
        uiLabel.textColor = .black
        uiLabel.font = .systemFont(ofSize: 15)
        uiLabel.textAlignment = .left
        return uiLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubViews(UIViews: [nameLabel, ageLabel, emailLabel])
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        ageLabel.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 10),
            nameLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -5),
            
            ageLabel.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 10),
            ageLabel.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            
            emailLabel.leadingAnchor.constraint(equalTo: ageLabel.trailingAnchor, constant: 10),
            emailLabel.bottomAnchor.constraint(equalTo: ageLabel.bottomAnchor),
            
            
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
