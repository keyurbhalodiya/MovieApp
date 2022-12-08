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
    func numberOfRows(for section: ListViewSectionModel.Section) -> Int
}

extension ListViewModel {
    /// Returns number of rows if there is any section at sepcified type
    /// - Parameter section: section type
    /// - Returns: Number of rows if there is any section at given type
    func numberOfRows(for section: ListViewSectionModel.Section) -> Int {
        guard let sectionModel = sectionModels.first(where: { $0.type == section }) else {
            return 0
        }
        return sectionModel.rows.count
    }
}
