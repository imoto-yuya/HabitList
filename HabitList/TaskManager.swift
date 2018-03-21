//
//  TaskManager.swift
//  HabitList
//
//  Created by Yuya Imoto on 2018/03/08.
//  Copyright © 2018年 Yuya Imoto. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class TaskManager {
    static let taskManager = TaskManager()
    private init() {}

    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var tasks: [Task] = []

    func fetchTask() {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "order", ascending: true)]
        do {
            tasks = []
            tasks = try context.fetch(fetchRequest)
        } catch {
            print("Fetching Failed")
        }
    }

    func updateOrder() {
        var order: Int16 = 0
        for task in tasks {
            task.order = order
            order += 1
        }
    }

    func copyTask(_ index: Int) -> Task {
        let outTask = Task(context: context)
        outTask.name = tasks[index].name
        outTask.check = tasks[index].check
        outTask.order = tasks[index].order
        return outTask
    }

    func insertTask(_ addTask: Task, _ insertIndex: Int) {
        tasks.insert(addTask, at: insertIndex)
        updateOrder()
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }

    func deleteTask(_ index: Int) {
        context.delete(tasks[index])
        tasks.remove(at: index)
        updateOrder()
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }

    func swichCheck(_ index: Int) {
        tasks[index].check = tasks[index].check ? false : true
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }

    func clearCheck() {
        for task in tasks {
            task.check = false
        }
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }

    func addNewTask(_ name: String) {
        let task = Task(context: context)
        task.name = name
        task.check = false
        insertTask(task, 0)
    }

    func editTask(_ name: String, _ index: Int) {
        let editTask = copyTask(index)
        editTask.name = name
        deleteTask(index)
        insertTask(editTask, index)
    }

    func sortTask(_ sourceIndexPath: Int, _ destinationIndexPath: Int) {
        let task = copyTask(sourceIndexPath)
        deleteTask(sourceIndexPath)
        insertTask(task, destinationIndexPath)
    }
}
