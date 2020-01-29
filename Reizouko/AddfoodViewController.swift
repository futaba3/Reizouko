//
//  AddfoodViewController.swift
//  Reizouko
//
//  Created by 工藤彩名 on 2018/12/01.
//  Copyright © 2018 Kudo Ayana. All rights reserved.
//

import UIKit
import UserNotifications
import YPImagePicker

class AddfoodViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate{
    
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
    
    // 個数の数字の配列
    var kosuArray:[Int] = ([Int])(1...20)
    
    // 通知設定に必要
    let center = UNUserNotificationCenter.current()
    var notificationTime = DateComponents()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 日付が入力されるまではOFF
        OnOffLabel.text = "OFF"
        notificationSwitch.setOn(false, animated: true)
        
        // ImageViewに画像が入っていない時、デフォルト画像を表示する
        if foodImageView.image == nil {
            let image = UIImage(named: "reizouko2.png")
            foodImageView.image = image
        }
        view.addSubview(foodImageView)
        
        // dateピッカーの設定
        datePicker.datePickerMode = UIDatePicker.Mode.date
        datePicker.timeZone = NSTimeZone.local
        datePicker.locale = Locale.current
        
        // 日付決定バーの生成
        let datetoolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
        let datespacelItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let datedoneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(datedone))
        datetoolbar.setItems([datespacelItem, datedoneItem], animated: true)
        
        // Delegate設定
        kosuPicker.delegate = self
        kosuPicker.dataSource = self
        
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
        
        // Do any additional setup after loading the view.
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
    
    // "撮影する"ボタンを押した時のメソッド
    @IBAction func takePhoto() {
//        // カメラが使えるかの確認
//        if UIImagePickerController.isSourceTypeAvailable(.camera) {
//
//            // カメラを起動
//            let picker = UIImagePickerController()
//            picker.sourceType =  .camera
//            picker.delegate = self
//
//            picker.allowsEditing = true
//
//            present(picker, animated: true, completion: nil)
//        } else {
//            // カメラが使えない時エラーがコンソールに出ます
//            print("error")
//        }
        showImagePicker()
    }
    
    // カメラロールにある画像を読み込む時のメソッド
    @IBAction func openAlbum() {
//        // カメラロールを使えるかの確認
//        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
//            // カメラロールの画像を選択して画像を表示するまでの一連の流れ
//            let picker = UIImagePickerController()
//            picker.sourceType = .photoLibrary
//            picker.delegate = self
//            
//            picker.allowsEditing = true
//            
//            present(picker, animated: true, completion: nil)
//        }
        showImagePicker()
    }
    
    // YPImagePickerで画像を選択する
    func showImagePicker() {
        var config = YPImagePickerConfiguration()
        // 作成した画像が保存されないようにする
        config.shouldSaveNewPicturesToAlbum = false
        config.startOnScreen = YPPickerScreen.library
        
        let picker = YPImagePicker(configuration: config)
        // カメラロールを使えるかの確認
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
        picker.didFinishPicking { [unowned picker] items, _ in
            if let photo = items.singlePhoto {
//                print(photo.fromCamera) // Image source (camera or library)
//                print(photo.image) // Final image selected by the user
//                print(photo.originalImage) // original image selected by the user, unfiltered
//                print(photo.modifiedImage) // Transformed image, can be nil
//                print(photo.exifMeta) // Print exif meta data of original image.
                
                if photo.modifiedImage == nil {
                    self.foodImageView.image = photo.originalImage
                } else {
                    self.foodImageView.image = photo.modifiedImage
                }
                
            }
            picker.dismiss(animated: true, completion: nil)
        }
        present(picker, animated: true, completion: nil)
        }
    }
    
//    // カメラ、カメラロールを使った時に選択した画像をアプリ内に表示するためのメソッド
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//
//        foodImageView.image = info[.editedImage] as? UIImage
//
//        dismiss(animated: true, completion: nil)
//    }
    
    
    
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
    }
    
    func saveFood(){
        // 配列の変数を定義する
        var names = self.saveData.array(forKey: "name") as? [String] ?? []
        var dates = self.saveData.array(forKey: "date") as? [String] ?? []
        var kosu = self.saveData.array(forKey: "kosu") as? [String] ?? []
        var memo = self.saveData.array(forKey: "memo") as? [String] ?? []
        var photo = self.saveData.array(forKey: "photo") as? [Data] ?? []
        var notificationIs = self.saveData.array(forKey: "notificationIs") as? [String] ?? []
        
        // 配列に今回入力したものを保存する
        names.append(self.nameTextField.text!)
        dates.append(self.dateTextField.text!)
        kosu.append(self.kosuTextField.text!)
        memo.append(self.memoTextView.text!)
        notificationIs.append(self.OnOffLabel.text!)
        
        // foodImageViewのimageをData型に変換
        let photoData = self.foodImageView.image!.pngData()!
        photo.append(photoData)
        
        // 配列を保存する
        self.saveData.set(names, forKey: "name")
        self.saveData.set(dates, forKey: "date")
        self.saveData.set(kosu, forKey: "kosu")
        self.saveData.set(memo, forKey: "memo")
        self.saveData.set(photo, forKey: "photo")
        self.saveData.set(notificationIs, forKey: "notificationIs")
    }
    
    // いれるボタン
    @IBAction func save(){
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
            let alert: UIAlertController = UIAlertController(title: "まいぞーこにいれますか？", message: nameTextField.text, preferredStyle: .alert)
            // OKボタン
            alert.addAction(
                UIAlertAction(
                    title: "はい",
                    style: .default,
                    handler: { action in
                        
                        // スイッチのオンオフで通知設定を変更
                        if self.OnOffLabel.text == "ON" {
                            self.saveFood()
                            self.notification()
                            print("通知を設定しました！")
                        } else {
                            self.saveFood()
                            // 通知は設定しない
                        }
                        
                        // メイン画面に移動する
                        self.navigationController?.popViewController(animated: true)
                        
                        print("はいボタンが押されました！")
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
