//
//  NetworkMethod.swift
//  MovieApp
//
//  Created by Bhalodiya, Keyur | Kb | ECMPD on 2022/12/06.
//

import Foundation

final class NetworkMethod {
    enum Method: String {
        case GET, POST, PUT, DELETE, PATCH
    }

    static func request(method: Method, url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        return request
    }
}

