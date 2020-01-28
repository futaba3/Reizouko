//
//  MyUINavigationController.swift
//  Reizouko
//
//  Created by 工藤彩名 on 2019/01/17.
//  Copyright © 2019 Kudo Ayana. All rights reserved.
//

import UIKit

class MyUINavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //　ナビゲーションバーの背景色
        navigationBar.barTintColor = .orange
        // ナビゲーションバーのアイテムの色　（戻る　＜　とか　読み込みゲージとか）
        navigationBar.tintColor = .white
        // ナビゲーションバーのテキストを変更する
        navigationBar.titleTextAttributes = [
            // 文字の色
            .foregroundColor: UIColor.white
        ]
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // ナビゲーションバーのアイテムの色　（戻る　＜　とか　読み込みゲージとか）
        navigationBar.tintColor = .white
    }
    

}

// navigationの入った画面はステータスバーの文字色を白にする
extension UINavigationController {
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
