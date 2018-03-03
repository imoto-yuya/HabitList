//
//  ViewController.swift
//  HabitList
//
//  Created by Yuya Imoto on 2018/02/22.
//  Copyright © 2018年 Yuya Imoto. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Properties

    @IBOutlet weak var taskTableView: UITableView!
    var plusButton: UIBarButtonItem?
    var strings = [String]()

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //データの準備
        self.strings.append("aaa")
        self.strings.append("bbb")
        self.strings.append("ccc")
        self.strings.append("ddd")
        self.strings.append("eee")
        self.taskTableView.dataSource = self
        // ナビゲーションバーに編集ボタンを追加
        self.navigationItem.setRightBarButton(self.editButtonItem, animated: true)
        //追加ボタンをプロパティとして持つ
        self.plusButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(plusButtonTapped(_:)))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)

        // 自分が持っているテーブルビューのeditingを更新する
        self.taskTableView.setEditing(editing, animated: animated)

        // 通常・編集モードの切り替え
        if editing {
            //プラスボタンをナビゲーションバーの左側へ表示させる。
            self.navigationItem.setLeftBarButton(self.plusButton, animated: true)
        } else {
            self.navigationItem.setLeftBarButton(nil, animated: true)
        }
    }

    @objc func plusButtonTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "Add task", message: "Please input task", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addTextField(configurationHandler: nil)

        // Addボタンを追加
        let addAction = UIAlertAction(title: "Add", style: UIAlertActionStyle.default) { (action: UIAlertAction) in
            if let textField = alertController.textFields?.first {
                self.strings.insert(textField.text!, at: 0)
                self.taskTableView.insertRows(at: [IndexPath(row: 0, section:0)], with: UITableViewRowAnimation.right)
            }
        }
        alertController.addAction(addAction)

        // Cancelボタンを追加
        let cancelAction = UIAlertAction(title: "CANCEL", style: UIAlertActionStyle.cancel, handler: nil)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }
}

extension ViewController: UITableViewDataSource {

    // MARK: - Table View Data Source

    // セル数を決める
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.strings.count
    }

    // セルの内容を決める
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = self.strings[indexPath.row]
        return cell
    }
}
