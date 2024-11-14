//
//  TableViewController.swift
//  myAlarm
//
//  Created by 장고은 on 11/14/24.
//

import UIKit

var items = [String]()
var itemsImageFile = [String]()
    

class TableViewController: UITableViewController {
    @IBOutlet var tvListView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    @objc func updateTime() {
        let date = NSDate()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm aaa"
        
        let currentTime = formatter.string(for: date)
        
        for (index, item) in items.enumerated() {
            if currentTime == item {
                let alarmAlert = UIAlertController(title: "알람!", message: "알람 시간이 되었습니다!", preferredStyle: .alert)
                let alarmOffAction = UIAlertAction(title: "알람 끄기", style: .default, handler: { _ in
                    // 알람 삭제
                    items.remove(at: index)
                    itemsImageFile.remove(at: index)
                    let indexPath = IndexPath(row: index, section: 0)
                    self.tableView.deleteRows(at: [indexPath], with: .fade)
                })
                
                alarmAlert.addAction(alarmOffAction)
                present(alarmAlert, animated: true, completion: nil)
                
                // 알람 시간이 지나면 alert 꺼짐
                DispatchQueue.main.asyncAfter(deadline: .now() + 60) {
                    alarmAlert.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    // MARK: - Table view data source

    override func viewWillAppear(_ animated: Bool) {
        tvListView.reloadData()
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)

        cell.textLabel?.text = items[(indexPath as NSIndexPath).row]
        cell.imageView?.image = UIImage(named: itemsImageFile[(indexPath as NSIndexPath).row])

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            items.remove(at: (indexPath as NSIndexPath).row)
            itemsImageFile.remove(at: (indexPath as NSIndexPath).row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "삭제"
    }
    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let itemToMove = items[(fromIndexPath as NSIndexPath).row]
        let itemImageToMove = itemsImageFile[(fromIndexPath as NSIndexPath).row]
        items.remove(at: (fromIndexPath as NSIndexPath).row)
        itemsImageFile.remove(at: (fromIndexPath as NSIndexPath).row)
        items.insert(itemToMove, at: (to as NSIndexPath).row)
        itemsImageFile.insert(itemImageToMove, at: (to as NSIndexPath).row)
    }
}
