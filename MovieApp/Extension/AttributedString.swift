//
//  AttributedString.swift
//  MovieApp
//
//  Created by Bhalodiya, Keyur | Kb | ECMPD on 2022/12/08.
//

import UIKit

fileprivate enum AttributeConstant {
    static let titleAttributes = [
        .font: UIFont.boldSystemFont(ofSize: 14),
        .foregroundColor: UIColor.gray
    ] as [NSAttributedString.Key : Any]
    static let valueAttributes = [
        .font: UIFont.systemFont(ofSize: 14),
        .foregroundColor: UIColor.lightGray
    ] as [NSAttributedString.Key : Any]
}

extension NSAttributedString {
 
    static func getAttributedString(title: String, value: String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: "")
        attributedString.append(NSAttributedString(string: title, attributes: AttributeConstant.titleAttributes))
        attributedString.append(NSAttributedString(string: value, attributes: AttributeConstant.valueAttributes))
        return attributedString
    }
}
