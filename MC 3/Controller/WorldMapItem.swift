//
//  WorldMapItem.swift
//  MC 3
//
//  Created by Yosua Hoo on 24/08/18.
//  Copyright © 2018 Yosua Hoo. All rights reserved.
//

import Foundation

struct WorldMapItem : Codable {
    
    var title:String
    var completed:Bool
    var createdAt:Date
    var itemIdentifier:UUID
    
    func saveItem() {
        DataManager.save(self, with: itemIdentifier.uuidString)
    }
    
    func deleteItem() {
        DataManager.delete(itemIdentifier.uuidString)
    }
    
    mutating func markAsCompleted() {
        self.completed = true
        DataManager.save(self, with: itemIdentifier.uuidString)
    }
    
}
