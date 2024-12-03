//
//  MyDatabase.swift
//  SQLite
//
//  Created by 장세화 on 12/3/24.
//

import UIKit
import SQLite3

class DBManager {
    let DB_NAME = "my_db.sqlite"
    let TABLE_NAME = "my_table"
    let COL_ID = "id"
    let COL_NAME = "name"
    
    var db : OpaquePointer? = nil
    
    func openDatabase() {
        let dbFile = try! FileManager.default.url(for: .documentDirectory,
                                                  in: .userDomainMask,
                                                  appropriateFor: nil,
                                                  create: false)
            .appendingPathComponent(DB_NAME)
        
        if sqlite3_open(dbFile.path, &db) == SQLITE_OK {
            print("Opened!!")
            print(dbFile)
        } else {
            print("Unable to open DB")
        }
    }
    
    func createTable() {
        let createTableString = """
            CREATE TABLE IF NOT EXISTS \(TABLE_NAME)( \(COL_ID) INTEGER PRIMARY KEY AUTOINCREMENT,
                \(COL_NAME) TEXT);
        """
        
        var createTableStmt : OpaquePointer?
        
        print ("TABLE SQL: \(createTableString)")
        
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStmt, nil) == SQLITE_OK {
            if sqlite3_step(createTableStmt) == SQLITE_DONE {
                print("Successfully created.")
            }
            sqlite3_finalize(createTableStmt)  // 포인트 해제
        } else {
            let error = String(cString: sqlite3_errmsg(db)!)
            print("Table Error: \(error)")
        }
    }
    
    func insert() {
        var insertStmt: OpaquePointer?
        
        if sqlite3_prepare_v2(db, "insert into \(TABLE_NAME) values (null, ?)", -1, &insertStmt, nil) == SQLITE_OK {
            let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
            
            if sqlite3_bind_text(insertStmt, 1, "test1", -1, SQLITE_TRANSIENT) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("Text binding Failure: \(errmsg)")
                return
            }
            
            if sqlite3_step(insertStmt) == SQLITE_DONE {
                print("Successfully inserted.")
            } else {
                print("insert error.")
            }
            
            sqlite3_finalize(insertStmt)  // 포인트 해제
            
        } else {
            print("Insert statment is not prepared.")
        }
    }
    
    func update(_ name : String, id : Int32) {
        let query = "update \(TABLE_NAME) set \(COL_NAME) = ? where \(COL_ID) = ?"
        
        var updateStmt : OpaquePointer?
        
        if sqlite3_prepare(db, query, -1, &updateStmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Error preparing update: \(errmsg)")
            return
        }
        
        let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
        
        
        if sqlite3_bind_text(updateStmt, 1, name, -1, SQLITE_TRANSIENT) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Text binding Failure: \(errmsg)")
            return
        }
        
        if sqlite3_bind_int(updateStmt, id, 1) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Integer binding Failure: \(errmsg)")
            return
        }
        
        if sqlite3_step(updateStmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Update Failure: \(errmsg)")
            return
        }
        
        sqlite3_finalize(updateStmt)
    }
    
    func delete(_ id : Int) {
        let query = "delete from \(TABLE_NAME) where \(COL_ID) = ?"
        
        var deleteStmt : OpaquePointer?
        
        if sqlite3_prepare(db, query, -1, &deleteStmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Error preparing stmt: \(errmsg)")
            return
        }
        
        bindIntParams(deleteStmt!, no: 1, param: id)
        
        if sqlite3_step(deleteStmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Delete Failure: \(errmsg)")
            return
        }
        
        sqlite3_finalize(deleteStmt)
    }
    
    func getAllData() {
        let sql = "select * from \(TABLE_NAME)"
        
        var queryResult: OpaquePointer?
        
        if sqlite3_prepare(db, sql, -1, &queryResult, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Reading Error: \(errmsg)")
            return
        }
        
        while(sqlite3_step(queryResult) == SQLITE_ROW){
            let id = sqlite3_column_int(queryResult, 0)
            let name = String(cString: sqlite3_column_text(queryResult, 1))
            print("id: \(id) name: \(name)")
        }
        
        sqlite3_finalize(queryResult)
    }
    
    func getData(_ name: String) {
        let sql = "select * from \(TABLE_NAME) where \(COL_NAME) = `\(name)`"
        
        var queryResult: OpaquePointer?
        
        if sqlite3_prepare(db, sql, -1, &queryResult, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Reading Error: \(errmsg)")
            return
        }
        
        while(sqlite3_step(queryResult) == SQLITE_ROW){
            let id = sqlite3_column_int(queryResult, 0)
            let name = String(cString: sqlite3_column_text(queryResult, 1))
            print("id: \(id) name: \(name)")
        }
        
        sqlite3_finalize(queryResult)
    }
    
    func closeDatabase() {
        if sqlite3_close(db) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Database Close Error: \(errmsg)")
            return
        }
    }
    
    func dropTable() {
        if sqlite3_exec(db, "drop table if exists \(TABLE_NAME)", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Drop Error: \(errmsg)")
            return
        }
    }
    
    func bindTextParams(_ stmt: OpaquePointer, no: Int, param: String){
        let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
        
        if sqlite3_bind_text(stmt, Int32(no), param, -1, SQLITE_TRANSIENT) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Text binding Failure: \(errmsg)")
            return
        }
    }
    
    func bindIntParams(_ stmt: OpaquePointer, no: Int, param: Int){
        if sqlite3_bind_int(stmt, Int32(no), Int32(param)) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("Integer binding Failure: \(errmsg)")
            return
        }
    }
}
