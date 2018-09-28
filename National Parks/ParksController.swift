//
//  Parks.swift
//  National Parks
//
//  Created by Oliver San Juan on 9/16/18.
//  Copyright © 2018 Oliver San Juan. All rights reserved.
//

import UIKit
import GRDB

//TODO:
//Reduce the amount of queries made to make this app more performant

class ParkCell : UITableViewCell
{
    @IBOutlet weak var Name: UILabel!
    
    @IBOutlet weak var State: UILabel!
    
    @IBOutlet weak var Region: UILabel!
}

class ParksController : UIViewController, UITableViewDataSource, UITableViewDelegate
{
    var parks = [Park]()
    var dbPath = "NULL"
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if let cell = tableView.cellForRow(at: indexPath)
        {
            cell.accessoryType = (cell.accessoryType == .none) ? .checkmark : .none
            let currentParkName = cell.textLabel?.text
            if let index = parks.index(where: {$0.name == currentParkName})
            {
                parks[index].visited = (cell.accessoryType == .none) ? false : true
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ParkCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = parks[indexPath.row].name
        cell.accessoryType = (parks[indexPath.row].visited == false) ? .none : .checkmark
        cell.detailTextLabel?.text = parks[indexPath.row].state
//        cell.Name?.text = parks[indexPath.row].name
//        cell.accessoryType = (parks[indexPath.row].visited == false) ? .none : .checkmark
//        cell.State?.text = parks[indexPath.row].state
//        cell.Region?.text = parks[indexPath.row].region
        return cell
    }
    
    func openDatabaseAndRetrieveContents() throws
    {
        //TODO: Create a singleton object and only open up the database if the contents are empty
        let fileManager = FileManager.default
        dbPath = try fileManager
            .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("db")
            .path
        
        let dbQueue = try DatabaseQueue(path: dbPath)
            let rows = try dbQueue.read { db in
                try Row.fetchAll(db, "SELECT * FROM Parks")
            }

            for row in rows{
                parks.append(Park(row["Name"], row["State"], row["Region"], row["visited"]))
            }

            parks.sort {$0.name < $1.name}
        
//            for park in parks
//            {
//                print(park.name)
//                print(park.state)
//                print(park.region)
//                print(park.visited)
//            }

    }
    
    func updateDatabase() throws
    {
        let dbQueue = try DatabaseQueue(path: dbPath)
        for park in parks{
            try dbQueue.write{db in
                try db.execute("UPDATE Parks SET visited = :visited WHERE Name = :name",
                               arguments: [park.visited, park.name])
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do
        {
             try openDatabaseAndRetrieveContents()
        }
        catch
        {
            print("Failed to open database and connect. Here's the error: \(error)")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    override func viewWillDisappear(_ animated: Bool) {
       
        do{
           try updateDatabase()
        }
        catch{
            print("Failed to update database!")
        }
        
       // print("Switching to the other view now!")
    }
}
