//
//  KyoukaExtension.swift
//  KyoukaExtension
//
//  Created by ZHRMoe on 2020/9/23.
//

import WidgetKit
import SwiftUI
import Intents

struct KyoukaServiceProvider: IntentTimelineProvider {
    
    static var lastClanInfo: KyoukaClanInfo? = nil
    static var lastError: Error? = nil
    
    func placeholder(in context: Context) -> KyoukaServiceEntry {
        KyoukaServiceEntry(date: Date(), clanInfo: KyoukaServiceProvider.lastClanInfo, error: KyoukaServiceProvider.lastError)
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (KyoukaServiceEntry) -> ()) {
        let entry = KyoukaServiceEntry(date: Date(), clanInfo: KyoukaServiceProvider.lastClanInfo, error: KyoukaServiceProvider.lastError)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let curDate = Date()
        var timeInterval: Int = 10
        if let configurationTimeInterval = configuration.timeInterval as? Int {
            timeInterval = configurationTimeInterval
        }
        let updateDate = Calendar.current.date(byAdding: .minute, value: timeInterval, to: curDate)
        KyoukaRequest.requestDataFromClanName(configuration.clanName ?? "") { (result) in
            switch result {
            case .success(let info):
                KyoukaServiceProvider.lastClanInfo = info
                KyoukaServiceProvider.lastError = nil
            case .failure(let error):
                KyoukaServiceProvider.lastError = error
            }
            let entry = KyoukaServiceEntry(date: updateDate!, clanInfo: KyoukaServiceProvider.lastClanInfo, error: KyoukaServiceProvider.lastError)
            let timeline = Timeline(entries: [entry], policy: .after(updateDate!))
            completion(timeline)
        }
    }
}

struct KyoukaServiceEntry: TimelineEntry {
    let date: Date
    let clanInfo: KyoukaClanInfo?
    let error: Error?
}

struct KyoukaClanInfo {
    var clan_name: String?
    var leader_name: String?
    var leader_viewer_id: Int?
    var damage: Int?
    var rank: Int?
}

struct KyoukaRequest {
    static func configRequestHeader(request: URLRequest) -> URLRequest {
        var _request = request
        _request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        _request.setValue("KyoukaOfficial", forHTTPHeaderField: "Custom-Source")
        _request.setValue("https://kyouka.kengxxiao.com", forHTTPHeaderField: "Origin")
        _request.setValue("https://kyouka.kengxxiao.com/", forHTTPHeaderField: "Referer")
        return _request
    }
    
    static func requestDataFromClanName(_ name: String, history: Int = 0, completion: @escaping (Result<KyoukaClanInfo, Error>) -> Void) {
        let urlString = "https://service-kjcbcnmw-1254119946.gz.apigw.tencentcs.com//name/0"
        let json = "{\"history\":\(history),\"clanName\":\"\(name)\"}"
        let url = URL(string: urlString)!
        let jsonData = json.data(using: .utf8, allowLossyConversion: false)!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request = KyoukaRequest.configRequestHeader(request: request)
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
            let processResult = processSingleClanInfo(fromData: data!)
            if processResult.0 != nil {
                completion(.success(processResult.0!))
            } else if processResult.1 != nil {
                completion(.failure(processResult.1!))
            } else {
                completion(.success(KyoukaClanInfo()))
            }
        }
        task.resume()
    }
    
    static func processSingleClanInfo(fromData data: Data) -> (KyoukaClanInfo?, Error?) {
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                guard let data = (json["data"] as? Array<[String: Any]>)?.first else { return (nil, nil)}
                var info = KyoukaClanInfo()
                info.clan_name = data["clan_name"] as? String
                info.leader_name = data["leader_name"] as? String
                info.leader_viewer_id = data["leader_viewer_id"] as? Int
                info.damage = data["damage"] as? Int
                info.rank = data["rank"] as? Int
                return (info, nil)
            } else {
                return (nil, nil)
            }
        } catch let error {
            return (nil, error)
        }
    }
}

struct KyoukaExtensionEntryView : View {
    var entry: KyoukaServiceProvider.Entry

    @Environment(\.widgetFamily) var family: WidgetFamily

    var body: some View {
        if entry.clanInfo != nil {
            switch family {
            case .systemSmall:
                VStack(alignment: .leading, spacing: nil) {
                    Text("公会名: \(entry.clanInfo!.clan_name ?? "")")
                    Text("伤害: \(entry.clanInfo!.damage ?? 0)")
                    Text("排名: \(entry.clanInfo!.rank ?? 0)")
                }
            default:
                VStack(alignment: .leading, spacing: nil) {
                    Text("公会名: \(entry.clanInfo!.clan_name ?? "")")
                    Text("会长ID: \(entry.clanInfo!.leader_name ?? "")")
                    Text("伤害: \(entry.clanInfo!.damage ?? 0)")
                    Text("排名: \(entry.clanInfo!.rank ?? 0)")
                }
            }
        } else {
            VStack(alignment: .leading, spacing: nil) {
                Text("发生错误: \(entry.error?.localizedDescription ?? "")")
            }
        }
    }
}

@main
struct KyoukaExtension: Widget {
    let kind: String = "KyoukaExtension"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: KyoukaServiceProvider()) { entry in
            KyoukaExtensionEntryView(entry: entry)
        }
        .configurationDisplayName("Kyouka工会战排名")
        .description("查询指定工会排名")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

struct KyoukaExtension_Previews: PreviewProvider {
    static var previews: some View {
        KyoukaExtensionEntryView(entry: KyoukaServiceEntry(date: Date(), clanInfo: KyoukaServiceProvider.lastClanInfo, error: KyoukaServiceProvider.lastError))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
