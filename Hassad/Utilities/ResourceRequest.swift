//
//  ResourceRequest.swift
//  Hassad
//
//  Created by gyda almohaimeed on 26/07/1444 AH.
//


import Foundation

struct ResourceRequest<ResourceType> where ResourceType: Codable {
  let baseURL = "http://localhost:8080/api/"
  let resourceURL: URL

  init(resourcePath: String) {
    guard let resourceURL = URL(string: baseURL) else {
      fatalError("Failed to convert baseURL to a URL")
    }
    self.resourceURL =
      resourceURL.appendingPathComponent(resourcePath)
  }
    
    
    func getAll(completion: @escaping(Result<[ResourceType], ResourceRequestError>) -> Void) {
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
    
    func save<CreateType>(_ saveData: CreateType, auth: Auth, completion: @escaping
              (Result<ResourceType, ResourceRequestError>) -> Void) where CreateType: Codable {
        do {
            guard let token = auth.token else {
                auth.logout()
                return
            }
            var urlRequest = URLRequest(url: resourceURL)
            urlRequest.httpMethod = "POST"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            urlRequest.httpBody = try JSONEncoder().encode(saveData)
            
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, _ in
                guard let httpResponse = response as? HTTPURLResponse else{
                    completion(.failure(.noData))
                    return
                }
                guard httpResponse.statusCode == 200, let jsonData = data else {
                    if httpResponse.statusCode == 401 {
                        auth.logout()
                    }
                    completion(.failure(.noData))
                    return
                }
                
                do{
                    
                    let resource = try JSONDecoder().decode(ResourceType.self, from: jsonData)
                    completion(.success(resource))
                    
                } catch {
                    completion(.failure(.decodingError))
                }
            }
            dataTask.resume()
        } catch {
            completion(.failure(.encodingError))
        }
        
    }
    
    
}
