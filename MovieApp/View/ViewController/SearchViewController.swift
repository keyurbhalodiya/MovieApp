//
//  SearchViewController.swift
//  MovieApp
//
//  Created by Bhalodiya, Keyur | Kb | ECMPD on 2022/12/04.
//

import UIKit
import Combine

final class SearchViewController: UIViewController, UICollectionViewDelegate {
    
    private enum Constant {
        static let searchDelay = 700
    }
    
    @IBOutlet private weak var movieCollectionView: UICollectionView!
    @IBOutlet weak var messageLabel: UILabel?
    @IBOutlet weak var searchBar: UISearchBar?
    
    private var subscriptions = Set<AnyCancellable>()
    private let viewModel = SearchViewModel(dataProvider: DataProvider())
    private var isLoading: Bool = false
    
    override func viewDidLoad() {
        setupCollectionView()
        setupSearchBarListeners()
        configureDataSource()
    }
    
    private func setupCollectionView() {
        movieCollectionView.register(UINib(nibName: MovieCell.identifier, bundle: nil), forCellWithReuseIdentifier: MovieCell.identifier)
        movieCollectionView?.keyboardDismissMode = UIScrollView.KeyboardDismissMode.onDrag
        movieCollectionView.delegate = self
        movieCollectionView.collectionViewLayout = .createLayout()
    }
    
    private func setupSearchBarListeners() {
        let publisher = NotificationCenter.default
            .publisher(for: UISearchTextField.textDidChangeNotification,
                       object: searchBar?.searchTextField)
        publisher
            .map {
                ($0.object as? UISearchTextField)?.text ?? ""
            }
            .debounce(for: .milliseconds(Constant.searchDelay), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] (searchText) in
                self?.scrollToTopIfNeeded()
                self?.searchMovie(searchText: searchText)
            }
            .store(in: &subscriptions)
    }
    
    private func scrollToTopIfNeeded() {
        guard !viewModel.sectionModels.isEmpty else { return }
        self.movieCollectionView?.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
    
    private func searchMovie(searchText: String) {
        guard !isLoading else { return }
        isLoading = true
        viewModel.searchMovieFeed(searchText: searchText) { [weak self] isSuccess in
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
        viewModel.dataSource = UICollectionViewDiffableDataSource<SearchViewModel.Section, SearchViewModel.Row>(collectionView: movieCollectionView) {
        (collectionView: UICollectionView, indexPath: IndexPath, row: SearchViewModel.Row?) -> UICollectionViewCell? in
            
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
}

// MARK: - UIScrollViewDelegate
extension SearchViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (((scrollView.contentOffset.y + scrollView.frame.size.height) > scrollView.contentSize.height) && !viewModel.shouldFinishLoading) {
            searchMovie(searchText: searchBar?.text ?? "")
        }
    }
    
    func searchBarSearchButtonClicked(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
}

