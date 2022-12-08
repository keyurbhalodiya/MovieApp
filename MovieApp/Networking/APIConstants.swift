//
//  APIConstants.swift
//  MovieApp
//
//  Created by Bhalodiya, Keyur | Kb | ECMPD on 2022/12/06.
//

import Foundation

enum APIConstants {
    private static let baseUrl = "https://api.themoviedb.org/3/"
    static let apiKey = "0e7274f05c36db12cbe71d9ab0393d47"
    static let nowPlaying = baseUrl + "movie/now_playing"
    static let popular = baseUrl + "movie/popular"
    static let topRated = baseUrl + "movie/top_rated"
    static let upcoming = baseUrl + "movie/upcoming"
    static let genreList = baseUrl + "genre/movie/list"
    static let movieDetails = baseUrl + "movie/"
    static let search = baseUrl + "search/movie"
    static let imageUrl = "https://image.tmdb.org/t/p/original"
    static let error = "Error"
    static let errorMessage = "Something went wrong! Please try again."
}
