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
    let resourceString = "https://hassadapp.herokuapp.com/api/users/\(userID)"
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
    
    func delete(auth: Auth){
        guard let token = auth.token else {
            auth.logout()
            return
        }
        var urlRequest = URLRequest(url: resourceURL)
        urlRequest.httpMethod = "DELETE"
        urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let dataTask = URLSession.shared.dataTask(with: urlRequest)
        dataTask.resume()
        auth.logout()
        
    }
    
      

    

}

