//
//  DataProvider.swift
//  MovieApp
//
//  Created by Bhalodiya, Keyur | Kb | ECMPD on 2022/12/06.
//

import Foundation

class DataProvider: NetworkHandler {
    
    var task: URLSessionTask?
    
    /// Generate task to fetch movie with page index param
    /// - Parameter completion: movieFeed or error.
    func fetchMovieFeedRepo(page: Int, completion: @escaping ((APIResult<MovieFeed, ErrorResult>) -> Void)) {
        self.cancelFetchService()
        let parameters: [String: String] = [
            "page": "\(page)",
            "api_key": APIConstants.apiKey
        ]
        task = NetworkService().loadData(urlString: APIConstants.nowPlaying, parameters: parameters, completion: self.networkResult(completion: completion))
    }
    
    /// Cancel session task.
    private func cancelFetchService() {
        if let task = task {
            task.cancel()
        }
        task = nil
    }
}
