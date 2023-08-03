//
//  APIManager.swift
//  CalendarApp
//
//  Created by Pradheep Narendran P on 28/07/23.
//

import Foundation

protocol APIProtocol {
    func processAPIRequest<T: Decodable>(request: URLRequest, memberType: T.Type, completionHandler: @escaping  (T?, Error?) -> Void)
}

extension APIProtocol {
    func processAPIRequest<T: Decodable>(request: URLRequest, memberType: T.Type, completionHandler: @escaping (T?, Error?) -> Void) {
        URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in            
            if let error = error {
                completionHandler(nil, error)
            } else {                
                let dataUW = try? JSONDecoder().decode(T.self, from: data!)
                completionHandler(dataUW, nil)
            }
        }).resume()
        
        
    }
}
