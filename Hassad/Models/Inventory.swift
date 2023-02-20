//
//  Inventory.swift
//  Hassad
//
//  Created by gyda almohaimeed on 29/07/1444 AH.
//

import Foundation

final class Inventory: Codable {
  var id: UUID?
  var inventoryname: String
  var inventoryprice: Double
  var quantity: Int


    
  var user: InventoryUser
    
   
    init(id: UUID? = nil, inventoryname: String, inventoryprice: Double, quantity: Int, userID: UUID) {
        self.id = id
        self.inventoryname = inventoryname
        self.inventoryprice = inventoryprice
        self.quantity = quantity
        let user = InventoryUser(id: userID)
        self.user = user
    }


}

final class InventoryUser: Codable {
  var id: UUID

  init(id: UUID) {
    self.id = id
  }
}






