//
//  AddViewController.swift
//  myAlarm
//
//  Created by 장고은 on 11/14/24.
//

import UIKit

class AddViewController: UIViewController {
    let timeSelector: Selector = #selector(AddViewController.updateTime)
    let interval = 1.0
    var alarmTime = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Timer.scheduledTimer(timeInterval: interval, target: self, selector: timeSelector, userInfo: nil, repeats: true)
    }
    
    @IBAction func btnAddItem(_ sender: UIButton) {
        items.append(alarmTime)
        itemsImageFile.append("clock.png")
        alarmTime = ""
        _ = navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func changeDatePicker(_ sender: UIDatePicker) {
        let datePickerView = sender
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm aaa"
        alarmTime = formatter.string(from: datePickerView.date)
    }
    
    @objc func updateTime() {
        let date = NSDate()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm aaa"
        
        if(alarmTime == ""){
            alarmTime = formatter.string(from: date as Date)
        }
    }
}
