//
//  SettingsViewController.swift
//  Reizouko
//
//  Created by 工藤彩名 on 2019/03/12.
//  Copyright © 2019 Kudo Ayana. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var table: UITableView!
    
    //項目を入れるための配列
    var sectionArray = [String]()

//    @IBOutlet var timeTextField: UITextField!

//    var timePicker: UIDatePicker = UIDatePicker()
    
//    var saveData: UserDefaults = UserDefaults.standard
    
//    var times: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //テーブルビューのデータソースメソッドはViewControllerクラスに書くよ、という設定
        table.dataSource = self
        
        //テーブルビューのデリゲートメソッドはViewControllerメソッドに書くよ、という設定
        table.delegate = self
        
        sectionArray = ["通知"]
        
//        // データを読み込む
//        timeTextField.text = saveData.object(forKey: "time") as? String
        
//        // stringの日付をDate型に直す
//        let formatter = DateFormatter()
//        formatter.dateFormat = "HH:mm"
//        formatter.locale = Locale(identifier: "ja_JP")
//        let times = timeTextField.text
//        let time = formatter.date(from: times!)
//
//        // timeピッカーの設定
//        timePicker.datePickerMode = UIDatePicker.Mode.time
//        timePicker.timeZone = NSTimeZone.local
//        timePicker.locale = Locale.current
//        timePicker.date = time ?? Date()
//
//        // 日付決定バーの生成
//        let timetoolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
//        let timespacelItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
//        let timedoneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(timedone))
//        timetoolbar.setItems([timespacelItem, timedoneItem], animated: true)
//
//        // インプットビューの設定
//        timeTextField.inputView = timePicker
//        timeTextField.inputAccessoryView = timetoolbar
        
    }
    
    // セルの数を設定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionArray.count
    }
    
    // ID付きのセルを取得して、セルに情報を表示する
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        
        // セルにsectionArrayを表示する
        cell?.textLabel?.text = sectionArray[indexPath.row]
        
        return cell!
    }
    
    // セルが押された時に呼ばれるメソッド
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // bundleを取得して本体の通知設定に飛ぶ
        guard let bundle = Bundle.main.bundleIdentifier else {
            return
        }
        let path = "app-settings:root=NOTIFICATIONS_ID&path=" + bundle
            if let url = URL(string: path) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }

        // セルの選択を解除
        tableView.deselectRow(at: indexPath, animated: true)
        print("\(sectionArray[indexPath.row])が選ばれました!")
    }
    
    
//    // 日付決定ボタン押す
//    @objc func timedone() {
//        timeTextField.endEditing(true)
//        
//        // 日付のフォーマット
//        let formatter = DateFormatter()
//        formatter.dateFormat = "HH:mm"
//        timeTextField.text = "\(formatter.string(from: timePicker.date))"
//        
//        // UserDefaultsに時刻を保存
//        self.saveData.set(times, forKey: "time")
//        
//        print(times)
//    }
    
}
