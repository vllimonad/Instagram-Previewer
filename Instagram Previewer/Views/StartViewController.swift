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
        navigationController?.navigationBar.barTintColor = UIColor(named: "background")
        logInButton.frame = CGRect(x: (view.frame.width/2)-70, y: 500, width: 140, height: 50)
        view.addSubview(logInButton)
    }
    
    @objc func login() {
        print(DataManager.shared.getURL().path())
        if FileManager().fileExists(atPath: DataManager.shared.getURL().path()){
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


/*
 /Users/uladzislau/Library/Developer/CoreSimulator/Devices/054F5857-E256-4099-B2DD-6CBB2B24A159/data/Containers/Data/Application/45C704E6-F68D-4B91-AB13-114146A5F72C/Documents/PhotosData.txt
 */
