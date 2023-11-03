//
//  LogInViewController.swift
//  Instagram Previewer
//
//  Created by Vlad Klunduk on 18/10/2023.
//

import UIKit

class StartViewController: UIViewController {
    
    var startViewModel: StartViewModel!
    private var showPassword: Bool = false
    
    private let usernameField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Phone number, username or email"
        textField.backgroundColor = .systemGray5
        textField.tintColor = UIColor(named: "text")
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.leftViewMode = .always
        textField.rightViewMode = .always
        textField.autocorrectionType = .no
        textField.layer.cornerRadius = 7
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let passwordField: UITextField = {
        var button = UIButton(type: .system)
        button.setTitle("  ", for: .normal)
        button.setImage(UIImage(systemName: "eye.slash", withConfiguration: UIImage.SymbolConfiguration(pointSize: 22, weight: .medium)), for: .normal)
        button.tintColor = UIColor.systemGray3
        button.addTarget(self, action: #selector(hideShowPassword(_:)), for: .touchUpInside)
            
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.backgroundColor = .systemGray5
        textField.tintColor = UIColor(named: "text")
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.rightView = button
        textField.leftViewMode = .always
        textField.rightViewMode = .always
        textField.autocorrectionType = .no
        textField.isSecureTextEntry = true
        textField.layer.cornerRadius = 7
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let logInButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(login), for: .touchUpInside)
        button.setTitle("Log In", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.tintColor = UIColor.white
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 7
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startViewModel = StartViewModel()
        startViewModel.delegate = self
        setupLayout()
        login()
    }
    
    func setupLayout() {
        view.addSubview(usernameField)
        view.addSubview(passwordField)
        view.addSubview(logInButton)
        
        NSLayoutConstraint.activate([
            usernameField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            usernameField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            usernameField.topAnchor.constraint(equalTo: view.topAnchor, constant: 300),
            usernameField.heightAnchor.constraint(equalToConstant: 50),
            
            passwordField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordField.topAnchor.constraint(equalTo: usernameField.bottomAnchor, constant: 10),
            passwordField.widthAnchor.constraint(equalTo: usernameField.widthAnchor, multiplier: 1),
            passwordField.heightAnchor.constraint(equalTo: usernameField.heightAnchor, multiplier: 1),
            
            logInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logInButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 30),
            logInButton.widthAnchor.constraint(equalTo: usernameField.widthAnchor, multiplier: 1),
            logInButton.heightAnchor.constraint(equalTo: usernameField.heightAnchor, multiplier: 1)

        ])
    }
    
    @objc func hideShowPassword(_ button: UIButton) {
        showPassword.toggle()
        passwordField.isSecureTextEntry.toggle()
        if showPassword {
            button.setImage(UIImage(systemName: "eye", withConfiguration: UIImage.SymbolConfiguration(pointSize: 22, weight: .medium)), for: .normal)
        } else {
            button.setImage(UIImage(systemName: "eye.slash", withConfiguration: UIImage.SymbolConfiguration(pointSize: 22, weight: .medium)), for: .normal)
        }
    }
    
    @objc func login() {
        //print(Saver().getURL().path())
        if FileManager().fileExists(atPath: File.getURL().path()){
            let v = ViewController()
            navigationController!.pushViewController(v, animated: true)
        } else {
            let vc = LogInViewController()
            vc.pushViewController = { [weak self] in
                let v = ViewController()
                self?.navigationController!.pushViewController(v, animated: true)
            }
            present(vc, animated: true)
        }
    }
}

extension StartViewController: StartViewModelDelegate {
    func getNavigationController() -> UINavigationController {
        return self.navigationController!
    }
}
