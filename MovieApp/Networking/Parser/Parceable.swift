//
//  Parceable.swift
//  MovieApp
//
//  Created by Bhalodiya, Keyur | Kb | ECMPD on 2022/12/06.
//

import Foundation

protocol Parceable {
    static func parseObject(data: Data) -> APIResult<Self, ErrorResult>
}

final class ParserHelper {
    /// parse object data from json data
    static func parse<T: Parceable>(data: Data, completion: (APIResult<T, ErrorResult>) -> Void) {
        switch T.parseObject(data: data) {
        case .failure(let error):
            completion(.failure(error))
            break
        case .success(let newModel):
            completion(.success(newModel))
            break
        }
    }
}

