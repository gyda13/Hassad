//
//  CreateProductData.swift
//  Hassad
//
//  Created by gyda almohaimeed on 27/07/1444 AH.
//

import Foundation

struct CreateProductData: Codable {
    let productname: String
    let laborcost: Double
    let actualcost: Double
    let totalprice: Double
    let profit: Double
    let quantity: Int
}

extension Product {
  func toCreateData() -> CreateProductData {
      CreateProductData(productname: self.productname, laborcost: self.laborcost, actualcost: self.actualcost, totalprice: self.totalprice, profit: self.profit, quantity: self.quantity)
  }
}

