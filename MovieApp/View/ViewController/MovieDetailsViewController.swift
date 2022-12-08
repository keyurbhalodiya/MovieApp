//
//  MovieDetailsViewController.swift
//  MovieApp
//
//  Created by Bhalodiya, Keyur | Kb | ECMPD on 2022/12/08.
//

import UIKit

final class MovieDetailsViewController: UIViewController, UITableViewDataSource {
    
    static let identifier = String(describing: MovieDetailsViewController.self)

    @IBOutlet weak var tableView: UITableView!
    var viewModel: MovieDetailsViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBar()
        setUpTableView()
        loadMovieDetails()
    }
    
    private func setNavigationBar() {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    private func setUpTableView() {
        tableView.register(UINib(nibName: MovieDetailsCell.identifier,
                                      bundle: nil),
                                forCellReuseIdentifier: MovieDetailsCell.identifier)
        tableView.dataSource = self
        tableView.estimatedRowHeight = 500.0
        tableView.rowHeight = UITableView.automaticDimension
    }

    private func loadMovieDetails() {
        viewModel?.loadMovieDetails(completion: { [weak self] result in
            guard let weakSelf = self else { return }
            DispatchQueue.main.async {
                weakSelf.tableView.isHidden = !result
                weakSelf.tableView.reloadData()
            }
        })
    }
}

// MARK: - UITableViewDataSource
extension MovieDetailsViewController {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == 0 ? 500 : UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let rowCount = viewModel?.sectionModel(at: section)?.rows.count else {
            return 0
        }
        return rowCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let row = viewModel?.row(at: indexPath) else {
            return UITableViewCell()
        }
        
        switch row {
        case .movieDetails(let details):
            if let cell = tableView.dequeueReusableCell(withIdentifier: MovieDetailsCell.identifier, for: indexPath) as? MovieDetailsCell {
                cell.style(details: details)
                return cell
            }
        }
        
        return UITableViewCell()
    }
}
