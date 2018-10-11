//
//  ObjectToSend.swift
//  MC 3
//
//  Created by Kennyzi Yusuf on 09/10/18.
//  Copyright © 2018 Yosua Hoo. All rights reserved.
//

import Foundation

//Custom class.
class NamaLubang: NSObject, NSCoding {
    func encode(with aCoder: NSCoder) {
        
    }
    
    var name: String!
    required convenience init(coder decoder: NSCoder) {
        self.init()
        self.name = decoder.decodeObject(forKey: "name") as? String
    }
    convenience init(name: String, age: Int) {
        self.init()
        self.name = name
    }
    func encodeWithCoder(coder: NSCoder) {
        if let name = name { coder.encode(name, forKey: "name") }
    }
}
