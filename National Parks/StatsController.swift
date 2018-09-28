//
//  StatsController.swift
//  National Parks
//
//  Created by Oliver San Juan on 9/25/18.
//  Copyright © 2018 Oliver San Juan. All rights reserved.
//

import UIKit
import GRDB

class StatsController : UIViewController
{
    var numOfParksVisited = 0
    
    @IBOutlet weak var totalParksVisited: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //TODO: It would be ideal to not rely on this
    func OpenDatabase() throws
    {
        var visited : Int
        
        //Reset the count
        numOfParksVisited = 0
        
        let fileManager = FileManager.default
        let dbPath = try fileManager
            .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("db")
            .path
        
        let dbQueue = try DatabaseQueue(path: dbPath)
        let rows = try dbQueue.read { db in
            try Row.fetchAll(db, "SELECT * FROM Parks")
        }
        
        for row in rows{
            
//            print(row["Name"])
//            print(row["State"])
//            print(row["visited"])
            
            visited = row["visited"]
            
            if(visited == 1)
            {
                numOfParksVisited = numOfParksVisited + 1
            }
        }
        
        totalParksVisited.text = String(numOfParksVisited)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        do
        {
            try OpenDatabase()
        }
        catch{
            print("Couldn't open the database!")
        }
    }
}
