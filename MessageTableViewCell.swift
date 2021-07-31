//
//  MessageTableViewCell.swift
//  Jared Cassoutt
//
//  Created by Jared Cassoutt on 7/20/21.
//

import Foundation
import UIKit

class MessageTableViewCell: UITableViewCell {
    
    var messageInfo: Message? {
        didSet {
            var isUserSender = false
            messageLabel.text = messageInfo!.content
            senderLabel.text = messageInfo!.user
            if messageInfo!.user == UserDefaults.standard.string(forKey: Constants.SignIn.username)! {
                isUserSender = true
            }
            else {
                isUserSender = false
            }
            setUpCell(isUserSender: isUserSender)
        }
    }
    
    
    private let messageLabel = UILabel(frame: .zero)
    private let senderLabel = UILabel(frame: .zero)
    private let borderView = UIView(frame: .zero)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.layoutIfNeeded()
     }

     required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    
    private func setUpCell(isUserSender: Bool) {
        //adding borderview
        addSubview(senderLabel)
        senderLabel.font = Constants.Fonts.boldSmallText
        senderLabel.textAlignment = .left
        senderLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            senderLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
            senderLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            senderLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            senderLabel.heightAnchor.constraint(equalToConstant: 14),
        ])
        
        addSubview(borderView)
        borderView.translatesAutoresizingMaskIntoConstraints = false
        borderView.layer.cornerRadius = 10
        borderView.addShadow(shadowColor: UIColor.label.cgColor, shadowOffset: CGSize(width: 0, height: 0), shadowOpacity: 0.25, shadowRadius: 2)
        
        //adding username label
        addSubview(borderView)
        borderView.translatesAutoresizingMaskIntoConstraints = false
        
        
        //formatting message depending on if it is from the current user or from another user
        if isUserSender {
            NSLayoutConstraint.activate([
                borderView.topAnchor.constraint(equalTo: senderLabel.bottomAnchor, constant: 3),
                borderView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
                borderView.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
                borderView.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            ])
            borderView.backgroundColor = UIColor().mainBlue
            messageLabel.textColor = .white
            messageLabel.sizeToFit()
            messageLabel.textAlignment = .right
            senderLabel.textAlignment = .right
        }
        else {
            NSLayoutConstraint.activate([
                borderView.topAnchor.constraint(equalTo: senderLabel.bottomAnchor, constant: 3),
                borderView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
                borderView.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
                borderView.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            ])
            borderView.backgroundColor = .secondarySystemBackground
            messageLabel.textColor = .label
            messageLabel.sizeToFit()
            messageLabel.textAlignment = .left
        }
        
        borderView.addSubview(messageLabel)
        messageLabel.font = Constants.Fonts.buttonText
        messageLabel.numberOfLines = 0
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: borderView.topAnchor, constant: 5),
            messageLabel.rightAnchor.constraint(equalTo: borderView.rightAnchor, constant: -10),
            messageLabel.bottomAnchor.constraint(equalTo: borderView.bottomAnchor, constant: -5),
            messageLabel.leftAnchor.constraint(equalTo: borderView.leftAnchor, constant: 10),
        ])
    }
    
}

