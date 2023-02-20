//
//  CreatInventoryData.swift
//  Hassad
//
//  Created by gyda almohaimeed on 29/07/1444 AH.
//
//

import Foundation

struct CreatInventoryData: Codable {

    let inventoryname: String
    let inventoryprice: Double
    let quantity: Int
}

extension Inventory {
  func toCreateData() -> CreatInventoryData {
      CreatInventoryData(inventoryname: self.inventoryname, inventoryprice: self.inventoryprice, quantity: self.quantity)
  }
}

