//
//  ProductRequest.swift
//  Hassad
//
//  Created by gyda almohaimeed on 27/07/1444 AH.
//


import Foundation

struct ProductRequest {
  let resource: URL

  init(productID: UUID) {
    let resourceString = "https://hassadapp.herokuapp.com/api/products/\(productID)"
    guard let resourceURL = URL(string: resourceString) else {
      fatalError("Unable to createURL")
    }
    self.resource = resourceURL
  }

  func update(
    with updateData: CreateProductData,
    auth: Auth,
    completion: @escaping (Result<Product, ResourceRequestError>) -> Void
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
          let product = try JSONDecoder().decode(Product.self, from: jsonData)
          completion(.success(product))
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
    
    
    func getUser(completion: @escaping (Result<User, ResourceRequestError>) -> Void){
        let url = resource.appendingPathComponent("user")
        let dataTask = URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let jsonData = data else {
                completion(.failure(.noData))
                return
            }
            do {
                let decoder = JSONDecoder()
                let user = try decoder.decode(User.self, from: jsonData)
                completion(.success(user))
            } catch {
                completion(.failure(.decodingError))
            }
        }
        dataTask.resume()
    }
    
}
