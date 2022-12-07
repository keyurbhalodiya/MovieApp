//
//  NetworkHandler.swift
//  MovieApp
//
//  Created by Bhalodiya, Keyur | Kb | ECMPD on 2022/12/06.
//

import Foundation

enum APIResult<T, E: Error> {
    case success(T)
    case failure(E)
}

enum ErrorResult: Error {
    case network(string: String)
    case parser(string: String)
    case custom(string: String)
}

class NetworkHandler {
    
    /// used to get object api response
    func networkResult<T: Parceable>(completion: @escaping ((APIResult<T, ErrorResult>) -> Void)) ->
    ((APIResult<Data, ErrorResult>) -> Void) {
        return { dataResult in
            DispatchQueue.global(qos: .background).async(execute: {
                switch dataResult {
                case .success(let data) :
                    ParserHelper.parse(data: data, completion: completion)
                    break
                case .failure(let error) :
                    print("Network error \(error)")
                    completion(.failure(.network(string: "Network error " + error.localizedDescription)))
                    break
                }
            })
        }
    }
}

