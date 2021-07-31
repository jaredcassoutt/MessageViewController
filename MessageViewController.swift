//
//  MessageViewController.swift
//  Jared Cassoutt
//
//  Created by Jared Cassoutt on 7/11/21.
//

import UIKit
import IQKeyboardManagerSwift

class MessageViewController: UIViewController, LoadingViewProtocol {
    
    var loadingView: LoadingView = LoadingView()
    
    let messageID = "messageID"
    
    let messageView = UIView(frame: .zero)
    let messageTextField = UITextField(frame: .zero)
    let sendMessageButton = UIButton(frame: .zero)
    var chatInfo: ChatInformation?
    var numberOfMessages = 0
    
    let chatTableView = UITableView(frame: .zero)
    let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        APIRequest()
    }
    
    func setUpUI() {
        setUpTextField()
        setUpTableView()
        hideKeyboardWhenTappedAround()
        IQKeyboardManager.shared.enable = true
        navigationItem.title = "Chat"
    }
    
    func setUpTextField() {
        view.addSubview(messageView)
        messageView.backgroundColor = .systemBackground
        messageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            messageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            messageView.rightAnchor.constraint(equalTo: view.rightAnchor),
            messageView.leftAnchor.constraint(equalTo: view.leftAnchor),
            messageView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        messageView.addSubview(sendMessageButton)
        sendMessageButton.addTarget(self, action: #selector(sendNewMessage), for: .touchUpInside)
        sendMessageButton.setImage(UIImage(systemName: Constants.Images.System.send), for: .normal)
        sendMessageButton.tintColor = .label
        sendMessageButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sendMessageButton.topAnchor.constraint(equalTo: messageView.topAnchor, constant: 8),
            sendMessageButton.bottomAnchor.constraint(equalTo: messageView.bottomAnchor, constant: -8),
            sendMessageButton.rightAnchor.constraint(equalTo: messageView.rightAnchor, constant: -8),
            sendMessageButton.widthAnchor.constraint(equalToConstant: 30),
        ])
        
        messageView.addSubview(messageTextField)
        messageTextField.borderStyle = .roundedRect
        messageTextField.backgroundColor = .secondarySystemBackground
        messageTextField.placeholder = "Send a message..."
        messageTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            messageTextField.centerYAnchor.constraint(equalTo: messageView.centerYAnchor),
            messageTextField.rightAnchor.constraint(equalTo: sendMessageButton.leftAnchor, constant: -8),
            messageTextField.leftAnchor.constraint(equalTo: messageView.leftAnchor, constant: 8),
            messageTextField.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    @objc func sendNewMessage() {
        let message = messageTextField.text
        messageTextField.resignFirstResponder()
        let username = UserDefaults.standard.string(forKey: Constants.SignIn.username)!
        if message != "" || message != nil {
            ChatAPI.sendMessage(username: username, message: message!) { _ in
                DispatchQueue.main.async {
                    self.APIRequest()
                }
            } failure: { errorResponse in
                DispatchQueue.main.async {
                    Displays().displayAlert(title: "Failed to Send Message", message: errorResponse)
                }
            }
        }
        messageTextField.text = ""
    }
    
    func APIRequest() {
        startLoading()
        ChatAPI.fetchChat { chatInfo in
            self.chatInfo = chatInfo
            self.numberOfMessages = chatInfo.messages.count
            self.chatTableView.reloadData()
            self.chatTableView.scrollToBottom()
            self.scrollToBottom()
            self.stopLoading()
            self.refreshControl.endRefreshing()
        } failure: { error in
            Displays().displayAlert(title: "Cannot Fetch Messages", message: "There was a problem loading the messages. Please check your connetion and try again later!")
        }

    }

}
extension MessageViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfMessages
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatTableView.dequeueReusableCell(withIdentifier: messageID, for: indexPath) as! MessageTableViewCell
        cell.messageInfo = chatInfo?.messages[indexPath.row]
        return cell
    }
    
    func setUpTableView() {
        view.addSubview(chatTableView)
        chatTableView.delegate = self
        chatTableView.dataSource = self
        chatTableView.separatorStyle = .none
        chatTableView.tableFooterView = UIView(frame: .zero)
        chatTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            chatTableView.topAnchor.constraint(equalTo: view.topAnchor),
            chatTableView.bottomAnchor.constraint(equalTo: messageView.topAnchor),
            chatTableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            chatTableView.leftAnchor.constraint(equalTo: view.leftAnchor),
        ])
        chatTableView.allowsSelection = false
        chatTableView.register(MessageTableViewCell.self, forCellReuseIdentifier: messageID)
        chatTableView.estimatedRowHeight = 44.0
        chatTableView.rowHeight = UITableView.automaticDimension
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        chatTableView.addSubview(refreshControl)
    }
    
    @objc func refresh(_ sender: AnyObject) {
        APIRequest()
    }
    
    func scrollToBottom() {
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.numberOfMessages-1, section: 0)
            self.chatTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
}

