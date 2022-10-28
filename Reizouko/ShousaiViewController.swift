//
//  ShousaiViewController.swift
//  Reizouko
//
//  Created by 工藤彩名 on 2018/11/18.
//  Copyright © 2018 Kudo Ayana. All rights reserved.
//

import UIKit
import UserNotifications
import YPImagePicker

class ShousaiViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    @IBOutlet var foodImageView: UIImageView!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var dateTextField: UITextField!
    @IBOutlet var kosuTextField: UITextField!
    @IBOutlet var memoTextView: UITextView!
    @IBOutlet var notificationSwitch: UISwitch!
    @IBOutlet var OnOffLabel: UILabel!
    
    var datePicker: UIDatePicker = UIDatePicker()
    var kosuPicker: UIPickerView = UIPickerView()
    var saveData: UserDefaults = UserDefaults.standard
    var dataArray: Array! = [Data]()
    
    var index: Int?
    
    var names: [String] = []
    var dates: [String] = []
    var kosu: [String] = []
    var memo: [String] = []
    var photo: [Data] = []
    var notificationIs: [String] = []
    
    // 個数の数字の配列
    var kosuArray:[Int] = ([Int])(1...20)
    
    // 通知設定に必要
    let center = UNUserNotificationCenter.current()
    var notificationTime = DateComponents()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 常にライトモード（明るい外観）を指定することでダークモード適用を回避（そのうちダークモードに対応したい）
        self.overrideUserInterfaceStyle = .light
        
        print(index!)
        
        // データを読み込む
        names = saveData.array(forKey: "name") as? [String] ?? []
        dates = saveData.array(forKey: "date") as? [String] ?? []
        kosu = saveData.array(forKey: "kosu") as? [String] ?? []
        memo = saveData.array(forKey: "memo") as? [String] ?? []
        photo = saveData.array(forKey: "photo") as? [Data] ?? []
        notificationIs = saveData.array(forKey: "notificationIs") as? [String] ?? []
        
        // index番目のを使う
        nameTextField.text = names[index!]
        dateTextField.text = dates[index!]
        kosuTextField.text = kosu[index!]
        memoTextView.text = memo[index!]
        foodImageView.image = UIImage(data: photo[index!])
        
        // indexがnotificationIsに存在していないときはoffに設定する
        guard index! >= 0 && index! < notificationIs.count else {
            print("index存在してないよ")
            // indexにnotificationIsをoffにして追加する
            var notificationIs = self.saveData.array(forKey: "notificationIs") as? [String] ?? []
            
            // 日付が設定されていたらオンにしておく
            if dateTextField.text == "" {
                OnOffLabel.text = "OFF"
                notificationIs.append("OFF")
                notificationSwitch.setOn(false, animated: true)
                
            } else {
                OnOffLabel.text = "ON"
                notificationIs.append("ON")
                notificationSwitch.setOn(true, animated: true)
                
            }
            
            self.saveData.set(notificationIs, forKey: "notificationIs")
            
            return
            
        }
            
        // indexがnotificationIsに存在していたらスイッチ切り替える
        OnOffLabel.text = notificationIs[index!]
        if let onOff = OnOffLabel.text {
            if onOff == "ON" {
                // スイッチオン
                notificationSwitch.setOn(true, animated: true)
            } else {
                // スイッチオフ
                notificationSwitch.setOn(false, animated: true)
            }
            
        }
        
        
//        // ImageViewに画像が入っていない時、デフォルト画像を表示する
//        if foodImageView.image == nil {
//            let image = UIImage(named: "reizouko2.png")
//            foodImageView.image = image
//        }
//        view.addSubview(foodImageView)
        //青にする(色)
        foodImageView.layer.borderColor = UIColor.orange.cgColor
               //線の太さ(太さ)
        foodImageView.layer.borderWidth = 5
        
        // stringの日付をDate型に直す
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        formatter.locale = Locale(identifier: "ja_JP")
        let date = formatter.date(from: dates[index!])
        
        // dateピッカーの設定
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = UIDatePicker.Mode.date
        datePicker.timeZone = NSTimeZone.local
        datePicker.locale = Locale.current
        datePicker.date = date ?? Date()
        
        // 日付決定バーの生成
        let datetoolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
        let datespacelItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let datedoneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(datedone))
        datetoolbar.setItems([datespacelItem, datedoneItem], animated: true)
        
        // Delegate設定
        kosuPicker.delegate = self
        kosuPicker.dataSource = self
        kosuPicker.selectRow((Int(kosu[index!]) ?? 0) - 1, inComponent: 0, animated: true)
        
        // 個数決定バーの生成
        let kosutoolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
        let kosuspacelItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let kosudoneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(kosudone))
        kosutoolbar.setItems([kosuspacelItem, kosudoneItem], animated: true)
        
        // インプットビュー設定
        dateTextField.inputView = datePicker
        dateTextField.inputAccessoryView = datetoolbar
        kosuTextField.inputView = kosuPicker
        kosuTextField.inputAccessoryView = kosutoolbar
        
        // 終わったらキーボードが閉じる
        nameTextField.delegate = self
    }
    
    // 名前入力後にキーボードが閉じる
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // 日付決定ボタン押す
    @objc func datedone() {
        dateTextField.endEditing(true)
        
        // 日付のフォーマット
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        dateTextField.text = "\(formatter.string(from: datePicker.date))"
        
        // 日付入力で自動的に通知オン
        OnOffLabel.text = "ON"
        notificationSwitch.setOn(true, animated: true)
    }
    
    // 個数決定ボタン押す
    @objc func kosudone() {
        kosuTextField.endEditing(true)
        
        // rowの意味について
        let row = kosuPicker.selectedRow(inComponent: 0)
        // テキストに表示する内容
        kosuTextField.text = String(kosuArray[row])
    }
    
    // 個数ロールの列数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // 個数ロールの行数
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return kosuArray.count
    }
    
    // kosuPickerに表示するデータを決めるメソッド
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        // 配列の値を文字列に変換してPickerのtitleに使う
        return String(kosuArray[row]) + "こ"
    }
    
    @IBAction func imageViewTapped(_ sender: Any) {
        showImagePicker()
    }
    
    func showImagePicker() {
        var config = YPImagePickerConfiguration()
//        config.isScrollToChangeModesEnabled = true
//        config.onlySquareImagesFromCamera = true
        config.usesFrontCamera = false
        config.showsPhotoFilters = false
        config.shouldSaveNewPicturesToAlbum = false
        config.startOnScreen = YPPickerScreen.photo
        config.screens = [.library, .photo]
        config.showsCrop = .none
        config.targetImageSize = YPImageSize.original
//        config.overlayView = UIView()
//        config.hidesStatusBar = true
//        config.hidesBottomBar = false
//        config.preferredStatusBarStyle = UIStatusBarStyle.default
        config.library.maxNumberOfItems = 1
        
        let picker = YPImagePicker(configuration: config)
        picker.didFinishPicking { [unowned picker] items, _ in
            if let photo = items.singlePhoto {
                self.foodImageView.image = photo.image
            }
            picker.dismiss(animated: true, completion: nil)
        }
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction func delete(){
        // 削除しますかアラート
        let alert: UIAlertController = UIAlertController(title: "さくじょしますか？", message: nameTextField.text, preferredStyle: .alert)
        // OKボタン
        alert.addAction(
            UIAlertAction(
                title: "はい",
                style: .default,
                handler: { action in
                    
                    // 削除する
                    self.names.remove(at: self.index!)
                    self.dates.remove(at: self.index!)
                    self.kosu.remove(at: self.index!)
                    self.memo.remove(at: self.index!)
                    self.photo.remove(at: self.index!)
                    self.notificationIs.remove(at: self.index!)
               
                    // 配列を保存する
                    self.saveData.set(self.names, forKey: "name")
                    self.saveData.set(self.dates, forKey: "date")
                    self.saveData.set(self.kosu, forKey: "kosu")
                    self.saveData.set(self.memo, forKey: "memo")
                    self.saveData.set(self.photo, forKey: "photo")
                    self.saveData.set(self.notificationIs, forKey: "notificationIs")
                    print("はいボタンが押されました！")
                    // メイン画面に移動する
                    self.navigationController?.popViewController(animated: true)
                }
            )
        )
        // キャンセルボタン
        alert.addAction(
            UIAlertAction(
                title: "いいえ",
                style: .cancel,
                handler: {action in
                    print("いいえボタンが押されました！")
                }
            )
        )
        present(alert, animated: true, completion: nil)
    }
    
    // 通知をつくるメソッド
    func notification() {
        let content = UNMutableNotificationContent()
        
        content.title = NSString.localizedUserNotificationString(forKey: "賞味期限が切れちゃうよ！！", arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey: "\(nameTextField.text!)の賞味期限は今日です", arguments: nil)
        content.sound = UNNotificationSound.default
        
        //通知する日付を設定
        let formatter = DateFormatter()
        
        notificationTime.year = Int(formatter.string(from: datePicker.date))
        notificationTime.month = Int(formatter.string(from: datePicker.date))
        notificationTime.day = Int(formatter.string(from: datePicker.date))
        notificationTime.hour = 7
        notificationTime.minute = 1
        notificationTime.second = 0
        
        // 通知の条件を設定
        let trigger = UNCalendarNotificationTrigger(dateMatching: notificationTime, repeats: false)
        // 通知のリクエストを生成
        let request = UNNotificationRequest(identifier: "Identifier", content: content, trigger: trigger)
        // 通知を登録
        center.add(request) { (error : Error?) in
            if error != nil {
                // エラー処理
            }
        }
    }
    
    // 通知オンオフスイッチ
    @IBAction func switchChange(_ sender: UISwitch) {
        // 日付がなければスイッチは動かせない
//        if dateTextField.text == "" {
//            // ボタン無効
//            OnOffLabel.isEnabled = false
//        }
        
        if dateTextField.text == "" {
            let alert: UIAlertController = UIAlertController(title: "期限を入力してください！", message: "期限がわからないので通知できません😢", preferredStyle: .alert)
            alert.addAction(
                UIAlertAction(
                    title: "もどる",
                    style: .cancel,
                    handler: { action in
                        self.notificationSwitch.setOn(false, animated: true)
                }
                    
                )
            )
            present(alert, animated: true, completion: nil)
            
        } else {
            
            if sender.isOn {
                // 通知を設定
                OnOffLabel.text = "ON"
                print("オンになっています")
            } else {
                OnOffLabel.text = "OFF"
                //通知は設定しない
            }
       }
//        let alert: UIAlertController = UIAlertController(title: "😭", message: "個別の通知設定はもう少しお待ちください", preferredStyle: .alert)
//        alert.addAction(
//            UIAlertAction(
//                title: "もどる",
//                style: .cancel,
//                handler: nil
//            )
//        )
//        present(alert, animated: true, completion: nil)
    }
    
    func saveEditFood() {
        // 編集したものに変える
        self.names[self.index!] = self.nameTextField.text!
        self.dates[self.index!] = self.dateTextField.text!
        self.kosu[self.index!] = self.kosuTextField.text!
        self.memo[self.index!] = self.memoTextView.text!
        self.photo[self.index!] = self.foodImageView.image!.pngData()!
        self.notificationIs[self.index!] = self.OnOffLabel.text!
        
        // foodImageViewのimageをData型に変換
        let photoData = self.foodImageView.image!.pngData()!
        
        // 配列を保存する
        self.saveData.set(self.names, forKey: "name")
        self.saveData.set(self.dates, forKey: "date")
        self.saveData.set(self.kosu, forKey: "kosu")
        self.saveData.set(self.memo, forKey: "memo")
        self.saveData.set(self.photo, forKey: "photo")
        self.saveData.set(notificationIs, forKey: "notificationIs")
        
    }
    
    // 保存するメソッド
    @IBAction func saveFood(){
        // なまえ入力されてないアラート
        if nameTextField.text == "" {
            let alert: UIAlertController = UIAlertController(title: "ちょっとまって", message: "なまえを入力してください！", preferredStyle: .alert)
            alert.addAction(
                UIAlertAction(
                    title: "もどる",
                    style: .cancel,
                    handler: nil
                )
            )
            present(alert, animated: true, completion: nil)
        }else{
            // 保存しますかアラートを出す
            let alert: UIAlertController = UIAlertController(title: "まいぞーこにいれなおしますか？", message: nameTextField.text, preferredStyle: .alert)
            // OKボタン
            alert.addAction(
                UIAlertAction(
                    title: "はい",
                    style: .default,
                    handler: { action in
                    
                        
                        // スイッチのオンオフで通知設定を変更
                        if self.OnOffLabel.text == "ON" {
                            self.saveEditFood()
                            self.notification()
                            print("通知を設定しました！")
                        } else {
                            self.saveEditFood()
                            // 通知は設定しない
                        }
                        
                        // メイン画面に移動する
                        self.navigationController?.popViewController(animated: true)
                        
                        print("いれるボタンが押されました！")
                        }
                )
            )
            // キャンセルボタン
            alert.addAction(
                UIAlertAction(
                    title: "いいえ",
                    style: .cancel,
                    handler: {action in
                        print("いいえボタンが押されました！")
                }
                )
            )
            present(alert, animated: true, completion: nil)
        }
    }
}
