//
//  ViewController.swift
//  DatePicker
//
//  Created by 장고은 on 9/20/24.
//

import UIKit

class DatePickerViewController: UIViewController {
    let timeSelector: Selector = #selector(DatePickerViewController.updateTime)
    let interval = 1.0
    var count = 0
    var alarmTime = ""
    
    @IBOutlet var lblCurrentTime: UILabel!
    @IBOutlet var lblPickerTime: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        Timer.scheduledTimer(timeInterval: interval, target: self, selector: timeSelector, userInfo: nil, repeats: true)
    }

    @IBAction func changeDatePicker(_ sender: UIDatePicker) {
        let datePickerView = sender
        
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm aaa"
        lblPickerTime.text = "선택시간: " + formatter.string(from: datePickerView.date)
        
        alarmTime = formatter.string(from: datePickerView.date)
    }
    
    @objc func updateTime() {
        // lblCurrentTime.text = String(count)
        // count = count + 1
        
        let date = NSDate()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm aaa"
        lblCurrentTime.text = "현재시간: " + formatter.string(from: date as Date)
        
        
        let currentTime = formatter.string(for: date)
        if (alarmTime == currentTime){
            view.backgroundColor = UIColor.red
        } else {
            view.backgroundColor = UIColor.white
        }
    }
}

