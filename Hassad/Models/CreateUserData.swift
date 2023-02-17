//
//  CreateUserData.swift
//  Hassad
//
//  Created by gyda almohaimeed on 26/07/1444 AH.
//

import Foundation

final class CreateUserData: Codable {
  var id: UUID?
  var businessname: String
  var email: String
  var password: String?

  init(businessname: String, email: String, password: String) {
    self.businessname = businessname
    self.email = email
    self.password = password
  }
}
