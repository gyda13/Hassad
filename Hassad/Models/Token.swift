//
//  Token.swift
//  Hassad
//
//  Created by gyda almohaimeed on 26/07/1444 AH.
//

import Foundation

final class Token: Codable {
  var id: UUID?
  var value: String
    

    
    var user: TokenUser
    
    
  init(value: String, userID: UUID) {
    self.value = value
      
      let user = TokenUser(id: userID)
      self.user = user
      
  }
}



final class TokenUser: Codable {
  var id: UUID

  init(id: UUID) {
    self.id = id
  }
}
