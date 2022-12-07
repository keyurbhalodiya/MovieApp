//
//  FeedViewController.swift
//  MovieApp
//
//  Created by Bhalodiya, Keyur | Kb | ECMPD on 2022/12/04.
//

import UIKit

final class FeedViewController: UIViewController {
    
    @IBOutlet private weak var moviePreferences: UISegmentedControl!
    @IBOutlet private weak var movieCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        let dataProvider = DataProvider()
        dataProvider.fetchMovieFeedRepo(page: 1) { result in
            switch result {
            case .success(let movie):
                print(movie)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func setupCollectionView() {
        movieCollectionView.register(UINib(nibName: MovieCell.identifier, bundle: nil), forCellWithReuseIdentifier: MovieCell.identifier)
    }
    
    @IBAction func movieTypesSelected(_ sender: UISegmentedControl) {
//        switch sender.selectedSegmentIndex {
//
//        }
   }
}
