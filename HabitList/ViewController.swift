//
//  ViewController.swift
//  HabitList
//
//  Created by Yuya Imoto on 2018/02/22.
//  Copyright © 2018年 Yuya Imoto. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate {

    // MARK: - Properties

    @IBOutlet weak var taskTableView: UITableView!
    var plusButton: UIBarButtonItem?
    var tasks = [Task]()
    var tasksToShow = [String]()

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.taskTableView.dataSource = self
        self.taskTableView.delegate = self
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
        let alertController = UIAlertController(title: "Add Task", message: "Please input task", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addTextField(configurationHandler: nil)

        // Addボタンを追加
        let addAction = UIAlertAction(title: "ADD", style: UIAlertActionStyle.default) { (action: UIAlertAction) in
            if let textField = alertController.textFields?.first {
                self.tasksToShow.insert(textField.text!, at: 0)
                self.taskTableView.insertRows(at: [IndexPath(row: 0, section:0)], with: UITableViewRowAnimation.right)
                let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

                // taskにTask(データベースのエンティティです)型オブジェクトを代入
                let task = Task(context: context)
                // 先ほど定義したTask型データのnameプロパティに入力、選択したデータを代入
                task.name = textField.text!
                // 上で作成したデータをデータベースに保存。
                (UIApplication.shared.delegate as! AppDelegate).saveContext()
            }
        }
        alertController.addAction(addAction)

        // Cancelボタンを追加
        let cancelAction = UIAlertAction(title: "CANCEL", style: UIAlertActionStyle.cancel, handler: nil)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        // CoreDataからデータをfetchしてくる
        getData()

        // taskTableViewを再読み込みする
        taskTableView.reloadData()
    }

    // MARK: - Method of Getting data from Core Data

    func getData() {
        // データ保存時と同様にcontextを定義
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            // CoreDataからデータをfetchしてtasksに格納
            let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
            tasks = try context.fetch(fetchRequest)

            // tasksToShow配列を空にする。（同じデータを複数表示しないため）
            tasksToShow = []

            // 先ほどfetchしたデータをtasksToShow配列に格納する
            for task in tasks {
                tasksToShow.insert(task.name!, at: 0)
            }

        } catch {
            print("Fetching Failed.")
        }
    }
}

extension ViewController: UITableViewDataSource {

    // MARK: - Table View Data Source

    // セル数を決める
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tasksToShow.count
    }

    // セルの内容を決める
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = self.tasksToShow[indexPath.row]
        return cell
    }
}
