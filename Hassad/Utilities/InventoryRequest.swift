//
//  InventoryRequest.swift
//  Hassad
//
//  Created by gyda almohaimeed on 29/07/1444 AH.
//


import Foundation

struct InventoryRequest {
  let resource: URL

  init(inventoryID: UUID) {
    let resourceString = "https://hassadapp.herokuapp.com/api/inventories/\(inventoryID)"
    guard let resourceURL = URL(string: resourceString) else {
      fatalError("Unable to createURL")
    }
    self.resource = resourceURL
  }

  func update(
    with updateData: CreatInventoryData,
    auth: Auth,
    completion: @escaping (Result<Inventory, ResourceRequestError>) -> Void
  ) {
    do {
      guard let token = auth.token else {
        auth.logout()
        return
      }
      var urlRequest = URLRequest(url: resource)
      urlRequest.httpMethod = "PUT"
      urlRequest.httpBody = try JSONEncoder().encode(updateData)
      urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
      urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
      let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, _ in
        guard let httpResponse = response as? HTTPURLResponse else {
          completion(.failure(.noData))
          return
        }
        guard
          httpResponse.statusCode == 200,
          let jsonData = data
        else {
          if httpResponse.statusCode == 401 {
            auth.logout()
          }
          completion(.failure(.noData))
          return
        }
        do {
          let invetory = try JSONDecoder().decode(Inventory.self, from: jsonData)
          completion(.success(invetory))
        } catch {
          completion(.failure(.decodingError))
        }
      }
      dataTask.resume()
    } catch {
      completion(.failure(.encodingError))
    }
  }

  
    

    func delete(auth: Auth){
        guard let token = auth.token else {
            auth.logout()
            return
        }
        var urlRequest = URLRequest(url: resource)
        urlRequest.httpMethod = "DELETE"
        urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let dataTask = URLSession.shared.dataTask(with: urlRequest)
        dataTask.resume()
    }

}

