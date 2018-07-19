//
//  MainViewController.swift
//  Slacker
//
//  Created by 寺家 篤史 on 2018/07/19.
//  Copyright © 2018年 Atsushi Jike. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if UserDefaults.accessToken == nil {
            presentAuthenticationWebViewController()
        }
    }

    private func presentAuthenticationWebViewController() {
        let vc = WebViewController(url: URL.authentication.beginUrl)
        let nc = UINavigationController(rootViewController: vc)
        present(nc, animated: true, completion: nil)
    }
}
