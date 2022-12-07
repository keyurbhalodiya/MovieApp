//
//  MovieFeedViewController.swift
//  MovieApp
//
//  Created by Bhalodiya, Keyur | Kb | ECMPD on 2022/12/04.
//

import UIKit

final class MovieFeedViewController: UIViewController, UICollectionViewDelegate {
    
    @IBOutlet private weak var moviePreferences: UISegmentedControl!
    @IBOutlet private weak var movieCollectionView: UICollectionView!
    @IBOutlet weak var messageLabel: UILabel?
    
    private let viewModel = MovieFeedViewModel(dataProvider: DataProvider())
    private var isLoading: Bool = false
    
    override func viewDidLoad() {
        setupCollectionView()
        configureDataSource()
        loadMovieData()
    }
    
    private func setupCollectionView() {
        movieCollectionView.register(UINib(nibName: MovieCell.identifier, bundle: nil), forCellWithReuseIdentifier: MovieCell.identifier)
        movieCollectionView.delegate = self
        movieCollectionView.collectionViewLayout = .createLayout()
    }
    
    private func loadMovieData(requestType: RequestType = .nowPlaying) {
        viewModel.loadMovieFeed(requestType: requestType) { [weak self] isSuccess in
            self?.updateUIElements(isSuccess: isSuccess)
        }
    }
    
    private func updateUIElements(isSuccess: Bool = true) {
        DispatchQueue.main.async {
            self.isLoading = false
            self.movieCollectionView?.isHidden = self.viewModel.sectionModels.isEmpty
            self.messageLabel?.isHidden = !self.viewModel.sectionModels.isEmpty
            self.movieCollectionView?.reloadData()
            if !isSuccess {
                self.showAlert(title: APIConstants.error, message: APIConstants.errorMessage)
            }
        }
    }
    
    private func configureDataSource() {
        viewModel.dataSource = UICollectionViewDiffableDataSource<MovieFeedViewModel.Section, MovieFeedViewModel.Row>(collectionView: movieCollectionView) {
        (collectionView: UICollectionView, indexPath: IndexPath, row: MovieFeedViewModel.Row?) -> UICollectionViewCell? in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.identifier, for: indexPath) as? MovieCell else { fatalError("Cannot create new cell")}

            switch row {
            case .movieFeed(let cellModel):
                cell.style(with: cellModel)
                return cell
            case .none:
                return UICollectionViewCell()
            }
        }
    }
    
    @IBAction func movieTypesSelected(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            loadMovieData(requestType: .nowPlaying)
        case 1:
            loadMovieData(requestType: .popular)
        case 2:
            loadMovieData(requestType: .topRated)
        case 3:
            loadMovieData(requestType: .upcoming)
        default:
            break
        }
   }
}

//MARK: - UICollectionViewDelegate Delegate
extension MovieFeedViewController {

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    }
    
    //Navigation
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    
    // Prepare Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
}
