//
//  ViewController.swift
//  demo
//
//  Created by YeWang on 2021/1/3.
//

import UIKit
import YWDatePickerView

class ViewController: UIViewController {

    @IBOutlet weak var dateField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let pickerView = YWDatePickerView. YWDatePickerView.createDatePickerView(.DateStyle_YearMonthDayHourMinute, false, { model in
//            debugPrint(model.year, model.month, model.day, model.hour, model.minute)
//        })
//        pickerView.minDate = Date()
//        dateField.inputView = pickerView
        // Do any additional setup after loading the view.
    }

    @IBAction func showDatePickerView(_ sender: Any) {
        
        YWDatePickerView.
    }
    
}

