//
//  DataProvider.swift
//  MovieApp
//
//  Created by Bhalodiya, Keyur | Kb | ECMPD on 2022/12/06.
//

import Foundation

enum RequestType {
    case nowPlaying
    case popular
    case topRated
    case upcoming
    case search
}

class DataProvider: NetworkHandler {
    
    var task: URLSessionTask?
    
    /// Generate task to fetch movie with page index param
    /// - Parameter page: index of page
    /// - Parameter searchText: default value is empty. Only pass value when search API call
    /// - Parameter completion: movieFeed or error.
    func fetchMovieFeed(page: Int, searchText:String = "", requestType: RequestType, completion: @escaping ((APIResult<MovieFeed, ErrorResult>) -> Void)) {
        self.cancelFetchService()
        var parameters: [String: String] = [
            "page": "\(page)",
            "api_key": APIConstants.apiKey,
        ]
        if requestType == .search {
            parameters["query"] = searchText
        }
        
        task = NetworkService().loadData(urlString: urlString(requestType: requestType), parameters: parameters, completion: self.networkResult(completion: completion))
    }
    
    /// API request url base on requestType
    private func urlString(requestType: RequestType) -> String {
        switch requestType {
        case .nowPlaying:
            return APIConstants.nowPlaying
        case .popular:
            return APIConstants.popular
        case .topRated:
            return APIConstants.topRated
        case .upcoming:
            return APIConstants.upcoming
        case .search:
            return APIConstants.search
        }
    }
    
    /// Cancel session task.
    private func cancelFetchService() {
        if let task = task {
            task.cancel()
        }
        task = nil
    }
}
