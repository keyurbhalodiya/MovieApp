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
    
    struct MovieFeedSectionModel: SectionModel {
        var type: Section
        var rows: [Row]
    }
    
    let dataProvider: DataProvider
    /// page index used in api request param. set to `1` when user change movie type tab
    private var pageIndex: Int = 1
    private var movieType: RequestType = .nowPlaying
    /// determine to used api needs to call when user scroll the list.
    /// set `true` once app receive all pages data loaded
    private(set) var shouldFinishLoading : Bool = false
    private(set) var sectionModels = [MovieFeedSectionModel]()
    
    var dataSource: UICollectionViewDiffableDataSource<Section, MovieFeedSectionModel.Row>! = nil

    init(dataProvider: DataProvider) {
        self.dataProvider = dataProvider
    }
    
    /// API call to fetch movie
    /// - Parameter completion: will be success or fail
    func loadMovieFeed(requestType: RequestType, completion: @escaping((Bool) -> Void)) {
        resetIndexAndSectionModelIfNeeded(requestType: requestType)
        dataProvider.fetchMovieFeed(page: pageIndex, requestType: requestType) { [weak self] result in
            guard let weakSelf = self else { return }
            var isSuccess: Bool = false
            switch result {
            case .success(let movie):
                weakSelf.generateSectionModels(movie: movie.results)
                weakSelf.pageIndex += 1
                weakSelf.shouldFinishLoading = weakSelf.pageIndex > movie.totalPages ?? 0
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
        shouldFinishLoading = false
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
        return movie.map({ Row.movieFeed(MovieCellModel(uuid: $0.uuid, movieId: $0.id, posterPath: $0.posterPath, title: $0.title, releaseDate: $0.releaseDate, voteAverage: $0.voteAverage, voteCount: $0.voteCount)) })
    }
    
    private func updateDataSource() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, MovieFeedSectionModel.Row>()
        snapshot.appendSections([.movieFeed])
        snapshot.appendItems(sectionModel(for: .movieFeed)?.rows ?? [])
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: - CollectionViewModel
extension MovieFeedViewModel {
    
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

