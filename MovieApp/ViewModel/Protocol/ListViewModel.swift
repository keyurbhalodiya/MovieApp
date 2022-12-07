//
//  ListViewModel.swift
//  MovieApp
//
//  Created by Bhalodiya, Keyur | Kb | ECMPD on 2022/12/07.
//

import Foundation

public protocol SectionModel {
    associatedtype Section: Equatable
    associatedtype Row

    var type: Section { get }
    var rows: [Row] { get }
}

public protocol ListViewModel {
    associatedtype ListViewSectionModel: SectionModel
    var sectionModels: [ListViewSectionModel] { get set }
    func row(at indexPath: IndexPath) -> ListViewSectionModel.Row?
}
