//
//  SearchViewModel.swift
//  MovieApp
//
//  Created by Bhalodiya, Keyur | Kb | ECMPD on 2022/12/07.
//

import UIKit

final class SearchViewModel {
    
    enum Section {
        case movieFeed
    }
    
    enum Row: Hashable {
        case movieFeed(MovieCellModel)
    }
    
    struct SearchViewSectionModel: SectionModel{
        var type: Section
        var rows: [Row]
    }
    
    private let dataProvider: DataProvider
    /// page index used in api request param. set to `1` when user change movie type tab
    private var pageIndex: Int = 1
    /// recent search keyword. get used to reset `pageIndex`
    private var recentSeachText: String = ""
    /// determine to used api needs to call when user scroll the list.
    /// set `true` once app receive all pages data loaded
    private(set) var shouldFinishLoading : Bool = false
    private(set) var sectionModels = [SearchViewSectionModel]()

    var dataSource: UICollectionViewDiffableDataSource<Section, SearchViewSectionModel.Row>! = nil

    init(dataProvider: DataProvider) {
        self.dataProvider = dataProvider
    }
    
    /// API call to fetch movie
    /// - Parameter searchText: search keyword
    /// - Parameter completion: will be success or fail
    func searchMovieFeed(searchText: String, completion: @escaping((Bool) -> Void)) {
        resetIndexAndSectionModelIfNeeded(searchText: searchText)
        dataProvider.fetchMovieFeed(page: pageIndex, searchText: searchText, requestType: .search) { [weak self] result in
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
    private func resetIndexAndSectionModelIfNeeded(searchText: String) {
        if recentSeachText != searchText || searchText.isEmpty {
            pageIndex = 1
            shouldFinishLoading = false
            sectionModels.removeAll()
        }
        recentSeachText = searchText
    }
    
    private func generateSectionModels(movie: [Result]?) {
        guard let searchViewSectionModel = searchViewSectionModel(movie: movie) else { return }
        sectionModels.removeAll()
        sectionModels.append(searchViewSectionModel)
        updateDataSource()
    }
    
    private func searchViewSectionModel(movie: [Result]?) -> SearchViewSectionModel? {
        let sectionModel = sectionModel(for: .movieFeed)
        guard let rows = moviesRows(movie: movie) else {
            return sectionModel
        }
        
        if var model = sectionModel {
            model.rows.append(contentsOf: rows)
            return model
        } else {
            return SearchViewSectionModel(type: .movieFeed, rows: rows)
        }
    }
    
    private func moviesRows(movie: [Result]?) -> [Row]? {
        guard let movie = movie, !movie.isEmpty else {
            return nil
        }
        return movie.map({ Row.movieFeed(MovieCellModel(uuid: $0.uuid, posterPath: $0.posterPath, title: $0.title, releaseDate: $0.releaseDate, voteAverage: $0.voteAverage, voteCount: $0.voteCount)) })
    }
    
    private func updateDataSource() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, SearchViewSectionModel.Row>()
        snapshot.appendSections([.movieFeed])
        snapshot.appendItems(sectionModel(for: .movieFeed)?.rows ?? [])
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: - CollectionViewModel
extension SearchViewModel {
    
    func sectionModel(for type: Section) -> SearchViewSectionModel? {
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

