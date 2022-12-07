//
//  MovieFeedViewModel.swift
//  MovieApp
//
//  Created by Bhalodiya, Keyur | Kb | ECMPD on 2022/12/07.
//

import Foundation
import UIKit

final class MovieFeedViewModel {
    
    enum Section {
        case movieFeed
    }
    
    enum Row: Hashable {
        case movieFeed(MovieCellModel)
    }
    
    struct MovieFeedSectionModel: SectionModel{
        var type: Section
        var rows: [Row]
    }
    
    private let dataProvider: DataProvider
    /// page index used in api request param. set to `1` when user change movie type tab
    private var pageIndex: Int = 1
    private var movieType: RequestType = .nowPlaying
    private(set) var sectionModels = [MovieFeedSectionModel]()

    var dataSource: UICollectionViewDiffableDataSource<Section, MovieFeedViewModel.Row>! = nil

    init(dataProvider: DataProvider) {
        self.dataProvider = dataProvider
    }
    
    /// API call to fetch movie
    /// - Parameter completion: will be success or fail
    func loadMovieFeed(requestType: RequestType, completion: @escaping((Bool) -> Void)) {
        resetIndexAndSectionModelIfNeeded(requestType: requestType)
        dataProvider.fetchMovieFeed(page: pageIndex, requestType: requestType) { [weak self] result in
            var isSuccess: Bool = false
            switch result {
            case .success(let movie):
                self?.generateSectionModels(movie: movie.results)
                isSuccess = true
            case .failure(_):
                break
            }
            completion(isSuccess)
        }
    }
    
    /// Reset pageIndex and sectionModels when requestType changed compare to previous one
    /// - parameters requestType: type of request
    private func resetIndexAndSectionModelIfNeeded(requestType: RequestType) {
        guard requestType != movieType else { return }
        sectionModels.removeAll()
        pageIndex = 1
        movieType = requestType
    }
    
    private func generateSectionModels(movie: [Result]?) {
        guard let movieFeedSectionModel = movieFeedSectionModel(movie: movie) else { return }
        sectionModels.removeAll()
        sectionModels.append(movieFeedSectionModel)
        updateDataSource()
    }
    
    private func movieFeedSectionModel(movie: [Result]?) -> MovieFeedSectionModel? {
        let sectionModel = sectionModel(for: .movieFeed)
        guard let rows = moviesRows(movie: movie) else {
            return sectionModel
        }
        
        if var model = sectionModel {
            model.rows.append(contentsOf: rows)
            return model
        } else {
            return MovieFeedSectionModel(type: .movieFeed, rows: rows)
        }
    }
    
    private func moviesRows(movie: [Result]?) -> [Row]? {
        guard let movie = movie, !movie.isEmpty else {
            return nil
        }
        return movie.map({ Row.movieFeed(MovieCellModel(posterPath: $0.posterPath, title: $0.title, releaseDate: $0.releaseDate, voteAverage: $0.voteAverage, voteCount: $0.voteCount)) })
    }
    
    private func updateDataSource() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, MovieFeedViewModel.Row>()
        snapshot.appendSections([.movieFeed])
        snapshot.appendItems(sectionModel(for: .movieFeed)?.rows ?? [])
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: - CollectionViewModel
extension MovieFeedViewModel {
    
    func sectionModel(at section: Int) -> MovieFeedSectionModel? {
        guard section >= 0, section < sectionModels.count else {
            return nil
        }
        return sectionModels[section]
    }
    
    func sectionModel(for type: Section) -> MovieFeedSectionModel? {
        return sectionModels.first(where: { $0.type == type })
    }
    
    func row(at indexPath: IndexPath) -> Row? {
        guard indexPath.section < sectionModels.count else {
            return nil
        }
        let section = sectionModels[indexPath.section]
        guard indexPath.row < section.rows.count else {
            return nil
        }
        return section.rows[indexPath.row]
    }
}

