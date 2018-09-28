//
//  Parks.swift
//  National Parks
//
//  Created by Oliver San Juan on 9/16/18.
//  Copyright © 2018 Oliver San Juan. All rights reserved.
//

import Foundation

class Park
{
    let name : String
    let state : String
    let region : String
    var visited : Bool
    
    init(_ name : String, _ state : String, _ region : String, _ visited : Int)
    {
        self.name = name
        self.state = state
        self.region = region
        self.visited = (visited == 0) ? false : true
    }
}
