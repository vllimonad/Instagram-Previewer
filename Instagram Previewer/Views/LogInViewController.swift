//
//  MainViewController.swift
//  Instagram Previewer
//
//  Created by Vlad Klunduk on 16/10/2023.
//

import UIKit
import WebKit

final class LogInViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {
    
    private var webView: WKWebView!
    private let urlString = "https://api.instagram.com/oauth/authorize?client_id=348133480999841&redirect_uri=https://socialsizzle.herokuapp.com/auth/&scope=user_profile,user_media&response_type=code"
    var logInViewModel: LogInViewModel!
    var closureConnection: (()->Void)!
    
    override func loadView() {
        webView = WKWebView()
        logInViewModel = LogInViewModel()
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        webView.load(URLRequest(url: URL(string: urlString)!))
        webView.addObserver(self, forKeyPath: "URL", context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "URL", (webView.url?.absoluteString)!.hasPrefix("https://socialsizzle.herokuapp.com/auth/?code=") {
            logInViewModel.getCodeFrom((webView.url?.absoluteString)!)
            dismiss(animated: true)
            closureConnection()
        }
    }
}