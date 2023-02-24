//
//  User.swift
//  Hassad
//
//  Created by gyda almohaimeed on 26/07/1444 AH.
//

import Foundation

final class User: Codable {
  var id: UUID?
  var businessname: String
  var email: String

  init(id: UUID? = nil, businessname: String, email: String) {
    self.id = id
    self.businessname = businessname
    self.email = email
  }
}

