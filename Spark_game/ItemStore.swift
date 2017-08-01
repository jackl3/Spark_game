//
//  ItemStore.swift
//  Spark_game
//
//  Created by jackl3 on 30/7/2017.
//  Copyright © 2017 jackl3. All rights reserved.
//

import UIKit
class ItemStore {
    var allItems = [Item]()
    func createItem() -> Item {
        let newItem = Item(random: true)
        
        allItems.append(newItem)
        
        return newItem
    }
    init() {
        for _ in 0..<5 {
            createItem()
        }
    }
}
