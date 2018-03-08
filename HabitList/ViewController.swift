//
//  ViewController.swift
//  HabitList
//
//  Created by Yuya Imoto on 2018/02/22.
//  Copyright © 2018年 Yuya Imoto. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK: - Properties

    @IBOutlet weak var taskTableView: UITableView!
    var plusButton: UIBarButtonItem?
    var tasks = [Task]()
    var tasksOfName = [String]()
    var tasksOfCheck = [Bool]()
    var isEditState: Bool = false

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.taskTableView.dataSource = self
        self.taskTableView.delegate = self
        // ナビゲーションバーに編集ボタンを追加
        self.navigationItem.setRightBarButton(self.editButtonItem, animated: true)
        // 追加ボタンをプロパティとして持つ
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
        isEditState = editing

        // 通常・編集モードの切り替え
        if isEditState {
            // プラスボタンをナビゲーションバーの左側へ表示させる。
            self.navigationItem.setLeftBarButton(self.plusButton, animated: true)
        } else {
            self.navigationItem.setLeftBarButton(nil, animated: true)
        }
    }

    @objc func plusButtonTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "Add Task", message: "", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addTextField(configurationHandler: {(textField: UITextField!) -> Void in
            textField.placeholder = "Input Task"
        })

        // Addボタンを追加
        let addAction = UIAlertAction(title: "ADD", style: UIAlertActionStyle.default) { (action: UIAlertAction) in
            if let textField = alertController.textFields?.first {
                // 追加するタスク名
                let addName = textField.text

                // ローカルデータの更新
                self.tasksOfName.insert(addName!, at: 0)
                self.tasksOfCheck.insert(false, at: 0)
                self.taskTableView.insertRows(at: [IndexPath(row: 0, section:0)], with: UITableViewRowAnimation.right)

                // CoreDataの更新
                let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                // taskにTask(データベースのエンティティです)型オブジェクトを代入
                let task = Task(context: context)
                // 先ほど定義したTask型データのnameプロパティに入力、選択したデータを代入
                task.name = addName!
                task.check = false
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

            // 最新のCoreDataにローカルデータを更新
            // tasksToShow配列を空にする。（同じデータを複数表示しないため）
            tasksOfName = []
            tasksOfCheck = []
            // 先ほどfetchしたデータをtasksToShow配列に格納する
            for task in tasks {
                tasksOfName.insert(task.name!, at: 0)
                tasksOfCheck.insert(task.check, at: 0)
            }

        } catch {
            print("Fetching Failed.")
        }
    }

    // MARK: - Table View Data Source

    // セル数を決める
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tasksOfName.count
    }

    // セルの内容を決める
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = taskTableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath)

        cell.textLabel?.text = self.tasksOfName[indexPath.row]
        if self.tasksOfCheck[indexPath.row] {
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
        } else {
            cell.accessoryType = UITableViewCellAccessoryType.none
        }
        return cell
    }

    // 全セルの削除許可
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    // セルの削除処理
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        if editingStyle == .delete {
            // 削除するタスク名
            let deletedName = tasksOfName[indexPath.row]

            // ローカルデータの更新
            tasksOfName.remove(at: indexPath.row)
            tasksOfCheck.remove(at: indexPath.row)

            // CoreDataの更新
            // 先ほど取得したnameに合致するデータのみをfetchするようにfetchRequestを作成
            let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "name = %@", deletedName)
            // そのfetchRequestを満たすデータをfetchしてtask(配列だが要素を1種類しか持たない)に代入し、削除する
            do {
                let task = try context.fetch(fetchRequest)
                context.delete(task[0])
            } catch {
                print("Fetching Failed.")
            }

            // 削除したタスクを保存する
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
        }
        // taskTableViewを再読み込みする
        taskTableView.reloadData()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        // タップしたタスク名
        let taskName = tasksOfName[indexPath.row]
        // 先ほど取得したnameに合致するデータのみをfetchするようにfetchRequestを作成
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name = %@", taskName)

        if isEditState {
            let alertController = UIAlertController(title: "Edit Task", message: "", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addTextField(configurationHandler: {(textField: UITextField!) -> Void in
                textField.text = taskName
            })

            // Editボタンを追加
            let editAction = UIAlertAction(title: "EDIT", style: UIAlertActionStyle.default) { (action: UIAlertAction) in
                // 編集したタスク名
                let editedName = alertController.textFields?.first?.text

                // ローカルデータの更新
                self.tasksOfName[indexPath.row] = editedName!

                // CoreDataの更新
                // そのfetchRequestを満たすデータをfetchして、それに代入する
                do {
                    let task = try context.fetch(fetchRequest)
                    task[0].name = editedName
                } catch {
                    print("Fetching Failed.")
                }
                // 編集したタスク名を保存
                (UIApplication.shared.delegate as! AppDelegate).saveContext()

                self.taskTableView.reloadData()
            }
            alertController.addAction(editAction)

            // Cancelボタンを追加
            let cancelAction = UIAlertAction(title: "CANCEL", style: UIAlertActionStyle.cancel, handler: nil)
            alertController.addAction(cancelAction)

            present(alertController, animated: true, completion: nil)
        } else {
            // checkするかどうか決める
            let isCheck = tasksOfCheck[indexPath.row] ? false : true

            // ローカルデータの更新
            tasksOfCheck[indexPath.row] = isCheck

            // CoreDataの更新
            do {
                let task = try context.fetch(fetchRequest)
                task[0].check = isCheck
            } catch {
                print("Fetching Failed.")
            }

            // 編集したcheckを保存
            (UIApplication.shared.delegate as! AppDelegate).saveContext()

            self.taskTableView.reloadData()
        }
    }
}
