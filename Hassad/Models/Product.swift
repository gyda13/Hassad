//
//  Product.swift
//  Hassad
//
//  Created by gyda almohaimeed on 27/07/1444 AH.
//

import Foundation

final class Product: Codable {
  var id: UUID?
  var productname: String
  var laborcost: Double
  var actualcost: Double
  var totalprice: Double
  var profit: Double
  var quantity: Int

    
  var user: ProductUser
    
    
    
    init(id: UUID? = nil, productname: String, laborcost: Double, actualcost: Double, totalprice: Double, profit: Double, quantity: Int, userID: UUID) {
        self.id = id
        self.productname = productname
        self.laborcost = laborcost
        self.actualcost = actualcost
        self.totalprice = totalprice
        self.profit = profit
        self.quantity = quantity
        
        let user = ProductUser(id: userID)
        self.user = user
    }


}

final class ProductUser: Codable {
  var id: UUID

  init(id: UUID) {
    self.id = id
  }
}
