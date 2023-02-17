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

  init(value: String) {
    self.value = value
  }
}
