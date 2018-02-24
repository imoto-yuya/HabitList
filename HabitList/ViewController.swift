//
//  ViewController.swift
//  HabitList
//
//  Created by Yuya Imoto on 2018/02/22.
//  Copyright © 2018年 Yuya Imoto. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {

    // MARK: - Properties

    @IBOutlet weak var taskTableView: UITableView!

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.taskTableView.dataSource = self
        // ナビゲーションバーに編集ボタンを追加
        self.navigationItem.setRightBarButton(self.editButtonItem, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table View Data Source

    // セル数を決める
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }

    // セルの内容を決める
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "section:[\(indexPath.section)], row:[\(indexPath.row)]"
        return cell
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)

        // 自分が持っているテーブルビューのeditingを更新する
        self.taskTableView.setEditing(editing, animated: animated)
    }
}

