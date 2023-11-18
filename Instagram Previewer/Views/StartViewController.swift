//
//  LogInViewController.swift
//  Instagram Previewer
//
//  Created by Vlad Klunduk on 18/10/2023.
//

import UIKit

final class StartViewController: UIViewController {
    
    private var logInButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(login), for: .touchUpInside)
        button.setTitle("Log In", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.tintColor = UIColor.white
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 7
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logInButton.frame = CGRect(x: (view.frame.width/2)-70, y: 500, width: 140, height: 50)
        view.addSubview(logInButton)
    }
    
    @objc func login() {
        if FileManager().fileExists(atPath: File.getURL().path()){
            let viewController = ViewController()
            navigationController!.pushViewController(viewController, animated: true)
        } else {
            let loginViewController = LogInViewController()
            loginViewController.pushViewController = { [weak self] in
                let viewController = ViewController()
                self?.navigationController!.pushViewController(viewController, animated: true)
            }
            present(loginViewController, animated: true)
        }
    }
}
