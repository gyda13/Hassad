//
//  UserRequest.swift
//  Hassad
//
//  Created by gyda almohaimeed on 04/08/1444 AH.
//


import Foundation

struct UserRequest<ResourceType> where ResourceType: Codable {
    let resourceURL: URL
    
  
  init(userID: UUID) {
    let resourceString = "http://127.0.0.1:8080/api/users/\(userID)"
    guard let resourceURL = URL(string: resourceString) else {
      fatalError("Unable to createURL")
    }
    self.resourceURL = resourceURL
  }


  
    func getUserInfo(completion: @escaping(Result<[ResourceType], ResourceRequestError>) -> Void) {
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
    
    func getOneUserInfo(completion: @escaping(Result<ResourceType, ResourceRequestError>) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: resourceURL) { data, _, _ in guard let jsonData = data else {
            completion(.failure(.noData))
            return
        }
            do{
                let resources = try JSONDecoder().decode(ResourceType.self, from: jsonData)
                completion(.success(resources))
            } catch {
                completion(.failure(.decodingError))
            }
        }
        
        dataTask.resume()
    }

    

}

