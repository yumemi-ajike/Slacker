//
//  WebViewController.swift
//  Slacker
//
//  Created by 寺家 篤史 on 2018/07/19.
//  Copyright © 2018年 Atsushi Jike. All rights reserved.
//

import UIKit
import WebKit
import SnapKit

class WebViewController: UIViewController {
    private let url: URL?
    private let webView = WKWebView(frame: .zero)

    init(url: URL? = nil) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(closeButtonSelected(sender:)))
        webView.navigationDelegate = self
        view.addSubview(webView)

        webView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        if let url = url {
            webView.load(URLRequest(url: url))
        }
    }

    @objc private func closeButtonSelected(sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}

extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let url = navigationAction.request.url else {
            decisionHandler(.cancel)
            return
        }

        if url.hasPrefix(URL.authentication.redirectUrl) {
            if let code = url.queryItem(for: "code") as? String {
                let request = Slack.OAuthAccess(clientId: String.app.clientId, clientSecret: String.app.clientSecret, code: code)
                Api.shared.send(request) { [weak self] (response, error) in
                    if let response = response {
                        print("response: \(response)")
                        UserDefaults.accessToken = response.accessToken
                        self?.dismiss(animated: true, completion: nil)
                    }
                    if let error = error {
                        print("error: \(error)")
                    }
                }
            }
            decisionHandler(.cancel)
            return
        }
        decisionHandler(.allow)
    }
}
