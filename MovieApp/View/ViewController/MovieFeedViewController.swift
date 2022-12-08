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
    private var segmentIndex = 0 {
        didSet {
            scrollToTopIfNeeded()
            loadMovieData()
        }
    }
    
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
    
    private func loadMovieData() {
        guard !isLoading else { return }
        var requestType: RequestType = .nowPlaying
        switch segmentIndex {
        case 0:
            requestType = .nowPlaying
        case 1:
            requestType = .popular
        case 2:
            requestType = .topRated
        case 3:
            requestType = .upcoming
        default:
            break
        }
        isLoading = true
        viewModel.loadMovieFeed(requestType: requestType) { [weak self] isSuccess in
            self?.updateUIElements(isSuccess: isSuccess)
        }
    }
    
    private func scrollToTopIfNeeded() {
        guard !viewModel.sectionModels.isEmpty else { return }
        self.movieCollectionView?.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
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
        segmentIndex = sender.selectedSegmentIndex
   }
}

//MARK: - UICollectionViewDelegate Delegate
extension MovieFeedViewController {
    //Navigation
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if case .movieFeed(let cellModel) = viewModel.row(at: indexPath), let movieId = cellModel.movieId {
            let viewController = self.storyboard!.instantiateViewController(withIdentifier: MovieDetailsViewController.identifier) as! MovieDetailsViewController
            let viewModel = MovieDetailsViewModel(dataProvider: viewModel.dataProvider, movieId: "\(movieId)")
            viewController.viewModel = viewModel
            viewController.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

// MARK: - UIScrollViewDelegate
extension MovieFeedViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (((scrollView.contentOffset.y + scrollView.frame.size.height) > scrollView.contentSize.height) && !viewModel.shouldFinishLoading) {
            loadMovieData()
        }
    }
}
