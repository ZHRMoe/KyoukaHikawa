//
//  ViewController.swift
//  KyoukaHikawa
//
//  Created by ZHRMoe on 2020/7/31.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }
    
    func configUI() {
        let button = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 200, height: 200))
        button.backgroundColor = .red
        button.center = CGPoint.init(x: self.view.frame.width / 2.0, y: self.view.frame.height / 2.0)
        button.addTarget(self, action: #selector(dataTest), for: .touchUpInside)
        self.view.addSubview(button)
    }

    @objc func dataTest() {
        KHNetwork.shared.requestDataAtRanking(5000, history: 0)
    }

}

