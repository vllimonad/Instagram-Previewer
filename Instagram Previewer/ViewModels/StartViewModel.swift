//
//  StartViewModel.swift
//  Instagram Previewer
//
//  Created by Vlad Klunduk on 24/10/2023.
//

import Foundation
import UIKit

class StartViewModel {
    
    var delegate: StartViewModelDelegate!
    
}

protocol StartViewModelDelegate {
    func getNavigationController() -> UINavigationController
}
