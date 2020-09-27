//
//  KHNetwork.swift
//  KyoukaHikawa
//
//  Created by ZHRMoe on 2020/7/31.
//

import Foundation
import Alamofire
import SwiftyJSON

let serverHost = "https://service-kjcbcnmw-1254119946.gz.apigw.tencentcs.com/"

class KHNetwork: NSObject {
    
    static let shared = KHNetwork()
    override init() {}
    
    fileprivate func configRequestHeader(request: URLRequest) -> URLRequest {
        var _request = request
        _request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        _request.setValue("KyoukaOfficial", forHTTPHeaderField: "Custom-Source")
        _request.setValue("https://kyouka.kengxxiao.com", forHTTPHeaderField: "Origin")
        _request.setValue("https://kyouka.kengxxiao.com/", forHTTPHeaderField: "Referer")
        return _request
    }
    
    func requestDefaultData() {
        let urlString = serverHost + "/default"
        let url = URL(string: urlString)!
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.rawValue
        request = self.configRequestHeader(request: request)
        
        AF.request(request).responseJSON { (responce) in
            if responce.value != nil {
                let resultJson = JSON.init(responce.value as Any)
                KHDefaultInfoManager.processDefaultInfo(json: resultJson)
            } else {
                
            }
        }
    }
    
    func requestDataAtRanking(_ ranking: Int, history: Int = 0) {
        let urlString = serverHost + "/rank/\(ranking)"
        let json = "{\"history\":\(history)}"
        let url = URL(string: urlString)!
        let jsonData = json.data(using: .utf8, allowLossyConversion: false)!
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request = self.configRequestHeader(request: request)
        request.httpBody = jsonData
        
        AF.request(request).responseJSON { (responce) in
            if responce.value != nil {
                let resultJson = JSON.init(responce.value as Any)
                KHClanInfoManager.processSingleClanInfo(json: resultJson)
            } else {
                
            }
        }
    }
    
    func requestDataFromClanName(_ name: String, history: Int = 0) {
        let urlString = serverHost + "/name/0"
        let json = "{\"history\":\(history),\"clanName\":\"\(name)\"}"
        let url = URL(string: urlString)!
        let jsonData = json.data(using: .utf8, allowLossyConversion: false)!
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request = self.configRequestHeader(request: request)
        request.httpBody = jsonData
        
        AF.request(request).responseJSON { (responce) in
            if responce.value != nil {
                let resultJson = JSON.init(responce.value as Any)
                KHClanInfoManager.processSingleClanInfo(json: resultJson)
            } else {
                
            }
        }
    }
    
}

