//
//  InventoryModelType.swift
//  Hassad
//
//  Created by gyda almohaimeed on 29/07/1444 AH.
//

import Foundation



enum InventoryModalType: Identifiable {
    var id: String {
        switch self {
        case .add: return "add"
        case .update: return "update"
        }
    }
    
case add
case update(Inventory)
    
    
}

