//
//  ViewController.swift
//  Reizouko
//
//  Created by 工藤彩名 on 2018/11/17.
//  Copyright © 2018 Kudo Ayana. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet var collectionView: UICollectionView!
    
    var names: [String] = []
    var dates: [String] = []
    var photo: [Data] = []
    
    var saveData: UserDefaults = UserDefaults.standard
    
    let center = UNUserNotificationCenter.current()

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // ナビゲーションバーの戻るボタンのテキスト変えたい
        let back = UIBarButtonItem()
        back.title = ""
        self.navigationItem.backBarButtonItem = back

        // 通知の許可を求める
        center.requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            // エラー処理
        }

    }
    
    // 開いた時に毎回読み込む
    override func viewWillAppear(_ animated: Bool) {
        names = saveData.array(forKey: "name") as? [String] ?? []
        dates = saveData.array(forKey: "date") as? [String] ?? []
        photo = saveData.array(forKey: "photo") as? [Data] ?? []
        collectionView.reloadData()
    }
    
    // セルが表示されるときに呼ばれる処理（1個のセルを描画する毎に呼び出される）
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:CustomCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as! CustomCell
        
        cell.foodimg.image = UIImage(data: photo[indexPath.row])
        cell.name.text = names[indexPath.row]
        cell.date.text = dates[indexPath.row]
        
        
        return cell
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // 表示するセルの数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return names.count
    }
    
    // 詳細画面への画面遷移
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "toShousai", sender: indexPath.row)
    }
    
    // セルのサイズを設定
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 画面の幅-(スペース*2)/3
        return CGSize(width: (self.view.frame.width - 10) / 3, height: (self.view.frame.width - 10) / 3)
    }
    
    // 画面遷移する時に呼び出される
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ShousaiViewController {
            vc.index = sender as? Int
        }
    }

}

