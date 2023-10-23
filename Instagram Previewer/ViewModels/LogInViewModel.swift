//
//  LogInViewModel.swift
//  Instagram Previewer
//
//  Created by Vlad Klunduk on 23/10/2023.
//

import Foundation

final class LogInViewModel {
    
    var code: String!
    var service: LogInModel!
    
    func getCodeFrom(_ url: String){
        var from = url.index(url.startIndex, offsetBy: "https://socialsizzle.herokuapp.com/auth/?code=".count)
        var to = url.lastIndex(of: "#")!
        code = String(url[from..<to])
        print(url[from..<to])
        getData()
    }
    
    func getData(){
        service = LogInModel()
        service.getAccessToken(for: code)
    }
    
    
    
}
