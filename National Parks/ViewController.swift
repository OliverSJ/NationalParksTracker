//
//  ViewController.swift
//  National Parks
//
//  Created by Oliver San Juan on 8/30/18.
//  Copyright © 2018 Oliver San Juan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    func copyDatabaseFile() throws
    {
        //We cannot directly make changes to the database in the Application bundle.
        //Instead, copy the database over to the application support directory and make the changes there
        //The app will make changes to this copy
        let fileManager = FileManager.default
        
        let dbPath = try fileManager
            .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            .appendingPathComponent("db")
            .path
        
        if !fileManager.fileExists(atPath: dbPath){
            let dbResourcePath = Bundle.main.path(forResource: "nationalparks", ofType: "db")!
            try fileManager.copyItem(atPath: dbResourcePath, toPath: dbPath)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        do
        {
            try copyDatabaseFile()
        }
        catch
        {
            print("Failed to copy the database file.")
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        performSegue(withIdentifier: "MainSegue" , sender: self)
    }
}

