//
//  MainViewController.swift
//  Slacker
//
//  Created by 寺家 篤史 on 2018/07/19.
//  Copyright © 2018年 Atsushi Jike. All rights reserved.
//

import UIKit

class MainViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "default")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if UserDefaults.accessToken.isEmpty {
            presentAuthenticationWebViewController()
        }
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
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "default", for: indexPath)
        cell.textLabel?.text = "Channels"
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationController?.pushViewController(ChannelsViewController(), animated: true)
    }
}
