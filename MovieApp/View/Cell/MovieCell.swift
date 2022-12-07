//
//  MovieCell.swift
//  MovieApp
//
//  Created by Bhalodiya, Keyur | Kb | ECMPD on 2022/12/04.
//

import UIKit

final class MovieCell: UICollectionViewCell {
    
    static let identifier = String(describing: MovieCell.self)
    
    @IBOutlet weak var wrapperView: UIView!
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var moviewDetails: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        wrapperView.layer.cornerRadius = 5
    }
}
