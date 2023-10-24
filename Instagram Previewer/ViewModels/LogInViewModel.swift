//
//  LogInViewModel.swift
//  Instagram Previewer
//
//  Created by Vlad Klunduk on 23/10/2023.
//

import Foundation

final class LogInViewModel {
    
    var code: String!
    var model: LogInModel!
    var apiService: APIService!
    
    func getCodeFrom(_ url: String){
        var from = url.index(url.startIndex, offsetBy: "https://socialsizzle.herokuapp.com/auth/?code=".count)
        var to = url.lastIndex(of: "#")!
        code = String(url[from..<to])
        print(url[from..<to])
        getData()
    }
    
    func getData(){
        model = LogInModel()
        model.getAccessToken(for: code)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1){
            self.apiService = APIService()
            self.apiService.access_token = self.model.user.access_token
            self.apiService.getContent()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                Saver().saveData(self.apiService.photos!)
            }
        }
    }
    
    
    
}
