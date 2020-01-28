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
    
    // 個数の数字の配列
    var kosuArray:[Int] = ([Int])(1...20)
    
    // 通知設定に必要
    let center = UNUserNotificationCenter.current()
    var notificationTime = DateComponents()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(index!)
        OnOffLabel.text = "ON"
        
        // データを読み込む
        names = saveData.array(forKey: "name") as? [String] ?? []
        dates = saveData.array(forKey: "date") as? [String] ?? []
        kosu = saveData.array(forKey: "kosu") as? [String] ?? []
        memo = saveData.array(forKey: "memo") as? [String] ?? []
        photo = saveData.array(forKey: "photo") as? [Data] ?? []
        
        // index番目のを使う
        nameTextField.text = names[index!]
        dateTextField.text = dates[index!]
        kosuTextField.text = kosu[index!]
        memoTextView.text = memo[index!]
        foodImageView.image = UIImage(data: photo[index!])
        
        // ImageViewに画像が入っていない時、デフォルト画像を表示する
        if foodImageView.image == nil {
            let image = UIImage(named: "reizouko2.png")
            foodImageView.image = image
        }
        view.addSubview(foodImageView)
        
        // stringの日付をDate型に直す
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        formatter.locale = Locale(identifier: "ja_JP")
        let date = formatter.date(from: dates[index!])
        
        // dateピッカーの設定
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
    @IBAction func takePhoto(){
//        // カメラが使えるかの確認
//        if UIImagePickerController.isSourceTypeAvailable(.camera) {
//
//            // カメラを起動
//            let picker = UIImagePickerController()
//            picker.sourceType = .camera
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
    @IBAction func openAlbum(){
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
               
                    // 配列を保存する
                    self.saveData.set(self.names, forKey: "name")
                    self.saveData.set(self.dates, forKey: "date")
                    self.saveData.set(self.kosu, forKey: "kosu")
                    self.saveData.set(self.memo, forKey: "memo")
                    self.saveData.set(self.photo, forKey: "photo")
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
       if sender.isOn {    //sender.isOnのみに省略可能
           // 通知を設定
           OnOffLabel.text = "ON"
           print("オンになっています")
       } else {
           OnOffLabel.text = "ON"
           //通知は設定しない
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
        
        // foodImageViewのimageをData型に変換
        let photoData = self.foodImageView.image!.pngData()!
        
        // 配列を保存する
        self.saveData.set(self.names, forKey: "name")
        self.saveData.set(self.dates, forKey: "date")
        self.saveData.set(self.kosu, forKey: "kosu")
        self.saveData.set(self.memo, forKey: "memo")
        self.saveData.set(self.photo, forKey: "photo")
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
                    
                        // 日付の入力がなければ通知は設定されない
                        if self.dateTextField.text == "" {
                            self.saveEditFood()
                            
                        } else {
                            
                            self.saveEditFood()
                            
                            // スイッチのオンオフで通知設定を変更
                            if self.OnOffLabel.text == "ON" {
                                self.notification()
                                print("通知を設定しました！")
                            } else {
                                // 通知は設定しない
                            }
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
