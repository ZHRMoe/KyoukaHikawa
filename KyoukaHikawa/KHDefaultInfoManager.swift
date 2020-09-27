//
//  KHDefaultInfoManager.swift
//  KyoukaHikawa
//
//  Created by ZHRMoe on 2020/9/27.
//

import Foundation
import SwiftyJSON

class KHDefalutInfo: NSObject {
    var ts: Int?
    var pastEventHistoryList: [KHTimestampInfo]?
    var currentEventHistoryList: [KHTimestampInfo]?
    var topTenInfos: [KHClanInfo]?
}

class KHTimestampInfo: NSObject {
    var timestamp: Int = 0
    var des: String = ""
}

extension KHTimestampInfo: Comparable {
    static func < (lhs: KHTimestampInfo, rhs: KHTimestampInfo) -> Bool {
        return lhs.timestamp < rhs.timestamp
    }
    
    static func > (lhs: KHTimestampInfo, rhs: KHTimestampInfo) -> Bool {
        return lhs.timestamp > rhs.timestamp
    }
}

class KHDefaultInfoManager: NSObject {
    
    static let shared = KHDefaultInfoManager()
    
    var defaultInfo: KHDefalutInfo? = nil
    
    override init() {
        super.init()
    }
    
    class func processDefaultInfo(json: JSON?) {
        let info = KHDefalutInfo()
        if let ts = json?["ts"].int {
            info.ts = ts
        }
        if let historyDic = json?["historyV2"].dictionary {
            var pastList: [KHTimestampInfo] = []
            var curList: [KHTimestampInfo] = []
            for item in historyDic {
                let temp = KHTimestampInfo()
                temp.timestamp = Int(item.key) ?? 0
                temp.des = item.value.stringValue
                if temp.des == "" {
                    curList.append(temp)
                } else {
                    pastList.append(temp)
                }
            }
            curList.sort(by: { $0 > $1 })
            pastList.sort(by: { $0 > $1 })
            info.currentEventHistoryList = curList
            info.pastEventHistoryList = pastList
        }
        if let data = json?["data"] {
            var list: [KHClanInfo] = []
            for item in data {
                let temp = KHClanInfo()
                temp.clan_name = item.1["clan_name"].string
                temp.leader_name = item.1["leader_name"].string
                temp.leader_viewer_id = item.1["leader_viewer_id"].int
                temp.damage = item.1["damage"].int
                temp.rank = item.1["rank"].int
                list.append(temp)
            }
            info.topTenInfos = list
        }
        KHDefaultInfoManager.shared.defaultInfo = info
    }
    
}
