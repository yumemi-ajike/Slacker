//
//  MainViewController.swift
//  Slacker
//
//  Created by 寺家 篤史 on 2018/07/19.
//  Copyright © 2018年 Atsushi Jike. All rights reserved.
//

import UIKit

class MainViewController: UITableViewController {
    struct Item {
        let name: String
        let value: String
        let identifier: String
    }
    private var items: [Item] = []
    private let footerView = UIView(frame: .zero)
    private let textView = MessageTextView(frame: .zero)
    private let sendButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Slacker"
        tableView.register(MainNameValueViewCell.self, forCellReuseIdentifier: "value1")
        textView.layer.borderColor = UIColor.green.cgColor
        textView.layer.borderWidth = 1
        textView.placeholder = "Message"
        footerView.addSubview(textView)
        sendButton.setTitle("Send", for: .normal)
        sendButton.addTarget(self, action: #selector(sendButtonSelected(sender:)), for: .touchUpInside)
        footerView.addSubview(sendButton)

        textView.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.height.equalTo(200)
            make.top.equalToSuperview()
        }
        sendButton.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.height.equalTo(40)
            make.top.equalTo(textView.snp.bottom).offset(10)
        }
    }

    override func viewWillLayoutSubviews() {
        if tableView.tableFooterView != textView {
            
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if UserDefaults.accessToken.isEmpty {
            presentAuthenticationWebViewController()
        }
        reload()
    }

    @objc private func sendButtonSelected(sender: UIButton) {
        if textView.text.isEmpty { return }

        textView.resignFirstResponder()
    }

    private func reload() {
        items.removeAll()
        items.append(Item(name: "Channels", value: "\(UserDefaults.channelIds.count) channels", identifier: "value1"))
        tableView.reloadData()
    }

    private func presentAuthenticationWebViewController() {
        let vc = WebViewController(url: URL.authentication.beginUrl)
        let nc = UINavigationController(rootViewController: vc)
        present(nc, animated: true, completion: nil)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: item.identifier, for: indexPath)
        if item.identifier == "value1" {
            cell.textLabel?.text = item.name
            cell.detailTextLabel?.text = item.value
            cell.accessoryType = .disclosureIndicator
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        if item.name == "Channels" {
            navigationController?.pushViewController(ChannelsViewController(), animated: true)
        }
    }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return footerView
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 260
    }
}

private class MainNameValueViewCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private class MessageTextView: UITextView {
    lazy var placeholderLabel = UILabel()
    var placeholder = ""

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        NotificationCenter.default.addObserver(self, selector: #selector(textViewTextDidChange(notification:)), name: .UITextViewTextDidChange, object: nil)
        placeholderLabel.textColor = .lightGray
        placeholderLabel.numberOfLines = 0
        addSubview(placeholderLabel)

        placeholderLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func textViewTextDidChange(notification: Notification) {
        placeholderLabel.isHidden = text.isEmpty
    }
}
