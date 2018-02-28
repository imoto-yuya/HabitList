//
//  AddTaskViewController.swift
//  HabitList
//
//  Created by Yuya Imoto on 2018/02/27.
//  Copyright © 2018年 Yuya Imoto. All rights reserved.
//

import UIKit

class AddTaskViewController: UIViewController {

    @IBOutlet weak var taskNameTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - Actions of Buttons
    @IBAction func backButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func okButtonTapped(_ sender: Any) {

        let taskName = taskNameTextField.text

        // TextFieldに入力がない場合、何もせず1つ目のViewに戻る
        if taskName == "" {
            dismiss(animated: true, completion: nil)
            return
        }

        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        let task = Task(context: context)
        task.name = taskName

        (UIApplication.shared.delegate as! AppDelegate).saveContext()

        dismiss(animated: true, completion: nil)
    }
}
