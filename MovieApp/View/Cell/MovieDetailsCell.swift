//
//  MovieDetailsCell.swift
//  MovieApp
//
//  Created by Bhalodiya, Keyur | Kb | ECMPD on 2022/12/08.
//

import UIKit
import SDWebImage
class MovieDetailsCell: UITableViewCell {
    
    static let identifier = String(describing: MovieDetailsCell.self)
    
    @IBOutlet weak var movieDetails: UILabel!
    @IBOutlet weak var moviePosterImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func style(details: MovieDetails) {
        if let posterPath = details.backdropPath {
            moviePosterImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            moviePosterImageView.sd_setImage(with: URL(string: APIConstants.imageUrl + "/\(posterPath)"), placeholderImage: UIImage(named: "moviePlaceHolder"))
        }

        movieDetails.attributedText = buildAttributeString(movieDetails: details)
    }
    
    private func buildAttributeString(movieDetails: MovieDetails) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: "")
        if let title = movieDetails.title {
            attributedString.append(NSAttributedString.getAttributedString(title: "Title: ", value: "\n\(title)"))
        }
        
        if let tagline = movieDetails.tagline {
            attributedString.append(NSAttributedString.getAttributedString(title: "\n\nTagline: ", value: "\n\(tagline)"))
        }
        
        if let overview = movieDetails.overview {
            attributedString.append(NSAttributedString.getAttributedString(title: "\n\nOverview: ", value: "\n\(overview)"))
        }
        
        if let releaseDate = movieDetails.releaseDate {
            attributedString.append(NSAttributedString.getAttributedString(title: "\n\nRelease Date: ", value: "\n\(releaseDate)"))
        }
        
        if let voteAverage = movieDetails.voteAverage {
            attributedString.append(NSAttributedString.getAttributedString(title: "\n\nVote Average: ", value: "\n\(voteAverage)"))
        }
        
        if let voteCount = movieDetails.voteCount {
            attributedString.append(NSAttributedString.getAttributedString(title: "\n\nVote Count: ", value: "\n\(voteCount)"))
        }
        return attributedString
    }
}
