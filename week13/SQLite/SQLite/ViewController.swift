//
//  ViewController.swift
//  SQLite
//
//  Created by 장세화 on 12/3/24.
//

import UIKit

class ViewController: UIViewController {

    var dbManager: DBManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dbManager = DBManager()
    }

    @IBAction func btnOpenDatabase(_ sender: UIButton) {
        dbManager?.openDatabase()
    }
    
    @IBAction func btnCreateTable(_ sender: UIButton) {
        dbManager?.createTable()
    }
    
    @IBAction func btnInsert(_ sender: UIButton) {
        dbManager?.insert()
    }
    
    @IBAction func btnSelectAll(_ sender: UIButton) {
        dbManager?.getAllData()
    }
    
    @IBAction func btnUpdate(_ sender: UIButton) {
        dbManager?.update("my_id", id: 2)
    }
    
    @IBAction func btnDelete(_ sender: UIButton) {
        dbManager?.delete(2)
    }
    
    @IBAction func btnDropTable(_ sender: UIButton) {
        dbManager?.dropTable()
    }
    
    @IBAction func btnCloseDatabase(_ sender: UIButton) {
        dbManager?.closeDatabase()
    }
}

