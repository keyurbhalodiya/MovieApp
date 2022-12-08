//
//  MovieCell.swift
//  MovieApp
//
//  Created by Bhalodiya, Keyur | Kb | ECMPD on 2022/12/04.
//

import UIKit
import SDWebImage

struct MovieCellModel: Hashable {
    let uuid: UUID
    let movieId: Int?
    let posterPath: String?
    let title: String?
    let releaseDate: String?
    let voteAverage: Double?
    let voteCount: Int?
}

final class MovieCell: UICollectionViewCell {
    
    static let identifier = String(describing: MovieCell.self)
    private static let titleAttributes = [
        .font: UIFont.boldSystemFont(ofSize: 14),
        .foregroundColor: UIColor.gray
    ] as [NSAttributedString.Key : Any]
    private static let valueAttributes = [
        .font: UIFont.systemFont(ofSize: 14),
        .foregroundColor: UIColor.lightGray
    ] as [NSAttributedString.Key : Any]
    
    @IBOutlet weak var wrapperView: UIView!
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var moviewDetails: UILabel!
    @IBOutlet weak var moviewTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        wrapperView.layer.cornerRadius = 5
    }
    
    func style(with cellModel: MovieCellModel) {
        moviewTitle.text = cellModel.title
        moviewDetails.attributedText = buildAttributeString(cellModel: cellModel)
        loadImage(path: cellModel.posterPath)
    }
    
    private func loadImage(path: String?) {
        guard let path = path else { return }
        movieImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        movieImageView.sd_setImage(with: URL(string: APIConstants.imageUrl + "/\(path)"), placeholderImage: UIImage(named: "moviePlaceHolder"))
    }
    
    private func buildAttributeString(cellModel: MovieCellModel) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: "")
        if let voteCount = cellModel.voteCount {
            attributedString.append(NSAttributedString.getAttributedString(title: "Vote Count: ", value: "\(voteCount)"))
        }
        
        if let voteAverage = cellModel.voteAverage {
            attributedString.append(NSAttributedString.getAttributedString(title: "\nVote Average: ", value: "\(voteAverage)"))
        }
        
        if let releaseDate = cellModel.releaseDate {
            attributedString.append(NSAttributedString.getAttributedString(title: "\nRelease Date: ", value: "\n\(releaseDate)"))
        }
        return attributedString
    }
}
