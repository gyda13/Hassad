//
//  TokenRequest.swift
//  Hassad
//
//  Created by gyda almohaimeed on 28/07/1444 AH.
//

//


//import Foundation
//
//struct TokenRequest {
//  let resource: URL
//
//  init(tokenID: String) {
//    let resourceString = "http://localhost:8080/api/tokens/\(tokenID)"
//    guard let resourceURL = URL(string: resourceString) else {
//      fatalError("Unable to createURL")
//    }
//    self.resource = resourceURL
//  }
//
//    func getUser(completion: @escaping (Result<User, ResourceRequestError>) -> Void){
//        let url = resource.appendingPathComponent("user")
//        let dataTask = URLSession.shared.dataTask(with: url) { data, _, _ in
//            guard let jsonData = data else {
//                completion(.failure(.noData))
//                return
//            }
//            do {
//                let decoder = JSONDecoder()
//                let user = try decoder.decode(User.self, from: jsonData)
//                completion(.success(user))
//            } catch {
//                completion(.failure(.decodingError))
//            }
//        }
//        dataTask.resume()
//    }
//
//
//
//
//
//}
//
