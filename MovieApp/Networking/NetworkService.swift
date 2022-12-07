//
//  NetworkService.swift
//  MovieApp
//
//  Created by Bhalodiya, Keyur | Kb | ECMPD on 2022/12/06.
//

import Foundation

final class NetworkService {
    
    /// API call function for load data.
    /// - Parameter urlString: API URL
    /// - Parameter session: session object
    /// - Parameter completion: Result. Will be success or fail
    func loadData(urlString: String, parameters: [String: String]?, session: URLSession = URLSession(configuration: .default), completion: @escaping (APIResult<Data, ErrorResult>) -> Void) -> URLSessionTask? {
        guard let url = URLComponents(string: urlString) else {
            completion(.failure(.network(string: "Wrong url format")))
            return nil
        }
        var components: URLComponents = url
        components.queryItems = parameters?.map { (key, value) in
            URLQueryItem(name: key, value: value)
        }
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        
        var request = NetworkMethod.request(method: .GET, url: components.url!)
        if let reachability = Reachability(), !reachability.isReachable {
            request.cachePolicy = .returnCacheDataDontLoad
        }
        let task = session.dataTask(with: request) { (data, _, error) in
            if let error = error {
                completion(.failure(.network(string: "An error occured during request :" + error.localizedDescription)))
                return
            }
            if let data = data {
                completion(.success(data))
            }
        }
        task.resume()
        return task
    }
}

