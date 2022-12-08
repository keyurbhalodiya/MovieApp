//
//  MovieDetailsViewModel.swift
//  MovieApp
//
//  Created by Bhalodiya, Keyur | Kb | ECMPD on 2022/12/08.
//

import Foundation

final class MovieDetailsViewModel {
    
    enum Section {
        case movieDetails
    }
    
    enum Row {
        case movieDetails(MovieDetails)
    }
    
    struct MovieDetailsSectionModel: SectionModel {
        var type: Section
        var rows: [Row]
    }
    
    private let dataProvider: DataProvider
    private let movieId: String
    private(set) var sectionModels = [MovieDetailsSectionModel]()
    
    init(dataProvider: DataProvider, movieId: String) {
        self.dataProvider = dataProvider
        self.movieId = movieId
    }
    
    /// API call to fetch movie details
    /// - Parameter completion: will be success or fail
    func loadMovieDetails(completion: @escaping((Bool) -> Void)) {
        dataProvider.fetchMovieDetails(movieId: movieId) { [weak self] result in
            guard let weakSelf = self else { return }
            var isSuccess: Bool = false
            switch result {
            case .success(let movieDetails):
                weakSelf.generateSectionModels(movieDetails: movieDetails)
                isSuccess = true
            case .failure(let error):
                print(error)
                break
            }
            completion(isSuccess)
        }
    }
    
    private func generateSectionModels(movieDetails: MovieDetails?) {
        guard let movieDetails = movieDetails else { return }
        sectionModels.append(MovieDetailsSectionModel(type: .movieDetails, rows: [Row.movieDetails(movieDetails)]))
    }
}

// MARK: - CollectionViewModel
extension MovieDetailsViewModel {
    
    func sectionModel(at section: Int) -> MovieDetailsSectionModel? {
        guard section >= 0, section < sectionModels.count else {
            return nil
        }
        return sectionModels[section]
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
