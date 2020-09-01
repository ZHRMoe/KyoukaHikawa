//
//  KHClanInfoManager.swift
//  KyoukaHikawa
//
//  Created by ZHRMoe on 2020/8/7.
//

import UIKit
import SwiftyJSON

class KHClanInfo: NSObject {
    var clan_name: String?
    var leader_name: String?
    var leader_viewer_id: Int?
    var damage: Int?
    var rank: Int?
}

protocol KHClanInfoManagerDelegate: NSObjectProtocol {
    func currentInfoHasChanged()
}

class KHClanInfoManager: NSObject {
    
    static let shared = KHClanInfoManager()
    
    var delegate: KHClanInfoManagerDelegate? = nil
    var currentInfo: KHClanInfo? {
        didSet {
            if currentInfo != nil {
                self.delegate?.currentInfoHasChanged()
            }
        }
    }
    
    override init() {
        super.init()
    }
    
    class func processSingleClanInfo(json: JSON?) {
        guard let data = json?["data"].first?.1 else { return }
        let info = KHClanInfo()
        info.clan_name = data["clan_name"].string
        info.leader_name = data["leader_name"].string
        info.leader_viewer_id = data["leader_viewer_id"].int
        info.damage = data["damage"].int
        info.rank = data["rank"].int
        KHClanInfoManager.shared.currentInfo = info
    }
}
