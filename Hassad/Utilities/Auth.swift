//
//  Auth.swift
//  Hassad
//
//  Created by gyda almohaimeed on 26/07/1444 AH.
//

import Foundation
import UIKit

enum AuthResult {
  case success
  case failure
}

class Auth: ObservableObject {
  static let keychainKey = "BM-API-KEY"

  @Published
  private(set) var isLoggedIn = false

  init() {
    if token != nil {
      self.isLoggedIn = true
    }
  }
    var ui:UUID?
  var token: String? {
    get {
      Keychain.load(key: Auth.keychainKey)
    }
    set {
      if let newToken = newValue {
        Keychain.save(key: Auth.keychainKey, data: newToken)
      } else {
        Keychain.delete(key: Auth.keychainKey)
      }
      DispatchQueue.main.async {
        self.isLoggedIn = newValue != nil
      }
    }
  }

  func logout() {
    token = nil
  }

  func login(email: String, password: String, completion: @escaping (AuthResult) -> Void) {
    let path = "http://localhost:8080/api/users/login"
      guard let url = URL(string: path) else {
      fatalError("Failed to convert URL")
    }
    guard let loginString =
        ("\(email):\(password)"
            .data(using: .utf8)?
            .base64EncodedString()) else {
      fatalError("Failed to encode credentials")
    }
      
      var loginRequest = URLRequest(url: url)
      loginRequest.addValue("Basic \(loginString)", forHTTPHeaderField: "Authorization")
      loginRequest.httpMethod = "POST"
      
      let dataTask = URLSession.shared.dataTask(with: loginRequest){ data, response, _ in
          guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let jsonData = data else {
              completion(.failure)
              return
          }
          do {
              let token = try JSONDecoder().decode(Token.self, from: jsonData)
              self.token = token.value
              self.ui = token.user.id 
          } catch {
              completion(.failure)
          }
      }
      dataTask.resume()
  }
}
