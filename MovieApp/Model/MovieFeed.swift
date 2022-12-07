//
//  MovieFeed.swift
//  MovieApp
//
//  Created by Bhalodiya, Keyur | Kb | ECMPD on 2022/12/04.
//

import Foundation

// MARK: - MovieFeed
struct MovieFeed: Codable {
    let dates: Dates?
    let page: Int?
    let results: [Result]?
    let totalPages, totalResults: Int?

    enum CodingKeys: String, CodingKey {
        case dates, page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Dates
struct Dates: Codable {
    let maximum, minimum: String?
}

// MARK: - Result
struct Result: Codable {
    let adult: Bool?
    let backdropPath: String?
    let genreIDS: [Int]?
    let id: Int?
    let originalLanguage, originalTitle, overview: String?
    let popularity: Double?
    let posterPath, releaseDate, title: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

// MARK: - Parceable protocol
extension MovieFeed: Parceable {
    static func parseObject(data: Data) -> APIResult<MovieFeed, ErrorResult> {
        let decoder = JSONDecoder()
        if let result = try? decoder.decode(MovieFeed.self, from: data) {
            return APIResult.success(result)
        } else {
            return APIResult.failure(ErrorResult.parser(string: "Unable to parse response"))
        }
    }
}
