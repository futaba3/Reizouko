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
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            // NavigationBarの背景色の設定
            appearance.backgroundColor = .orange
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
            // NavigationBarのタイトルの文字色の設定
            appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            self.navigationController?.navigationBar.standardAppearance = appearance
            self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        } else {
            navigationBar.barTintColor = .orange
            // ナビゲーションバーのアイテムの色　（戻る　＜　とか　読み込みゲージとか）
            navigationBar.tintColor = .white
            // ナビゲーションバーのテキストを変更する
            navigationBar.titleTextAttributes = [
                // 文字の色
                .foregroundColor: UIColor.white
            ]
        }
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
