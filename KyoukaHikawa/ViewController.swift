//
//  ViewController.swift
//  KyoukaHikawa
//
//  Created by ZHRMoe on 2020/7/31.
//

import UIKit

class ViewController: UIViewController {
    
    var label = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        KHClanInfoManager.shared.delegate = self
        configUI()
    }
    
    func configUI() {
        let button = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 200, height: 200))
        button.center = CGPoint.init(x: self.view.frame.width / 2.0, y: self.view.frame.height / 2.0)
        button.backgroundColor = .red
        button.addTarget(self, action: #selector(dataTest), for: .touchUpInside)
        self.view.addSubview(button)
        
        label.frame = CGRect.init(x: 0, y: 600, width: self.view.frame.width, height: 200)
        label.numberOfLines = 0
        self.view.addSubview(label)
    }

    @objc func dataTest() {
//        KHNetwork.shared.requestDataAtRanking(1500, history: 0)
        KHNetwork.shared.requestDataFromClanName("救赎蔷薇", history: 0)
    }

}

extension ViewController: KHClanInfoManagerDelegate {
    func currentInfoHasChanged() {
        guard let info = KHClanInfoManager.shared.currentInfo else { return }
        label.text = "ClanName:\(info.clan_name!)\nLeaderName:\(info.leader_name!)\nDamage:\(info.damage!)\nRank:\(info.rank!)"
    }
    
}

