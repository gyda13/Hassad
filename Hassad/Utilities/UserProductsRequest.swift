//
//  UserProductsRequest.swift
//  Hassad
//
//  Created by gyda almohaimeed on 28/07/1444 AH.
//


import Foundation

struct UserProductsRequest<ResourceType> where ResourceType: Codable {
    let resourceURL: URL
    
  
  init(userID: UUID) {
    let resourceString = "https://hassadapp.herokuapp.com/api/users/\(userID)/products"
    guard let resourceURL = URL(string: resourceString) else {
      fatalError("Unable to createURL")
    }
    self.resourceURL = resourceURL
  }


  
    func getUserProduct(completion: @escaping(Result<[ResourceType], ResourceRequestError>) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: resourceURL) { data, _, _ in guard let jsonData = data else {
            completion(.failure(.noData))
            return
        }
            do{
                let resources = try JSONDecoder().decode([ResourceType].self, from: jsonData)
                completion(.success(resources))
            } catch {
                completion(.failure(.decodingError))
            }
        }
        
        dataTask.resume()
    }
    

    

}

