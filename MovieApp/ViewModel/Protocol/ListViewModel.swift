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
    var numberOfSections: Int { get }
    func numberOfRows(in section: Int) -> Int
    func numberOfRows(for section: ListViewSectionModel.Section) -> Int
    func row(at indexPath: IndexPath) -> ListViewSectionModel.Row?
    func sectionModel(at section: Int) -> ListViewSectionModel?
}

public extension ListViewModel {
    
    /// Returns number total section(s) in list
    var numberOfSections: Int {
        return sectionModels.count
    }
    
    /// Returns number of rows if there is any section at sepcified index
    /// - Parameter section: section index
    /// - Returns: Number of rows if there is any section at given index
    func numberOfRows(in section: Int) -> Int {
        guard let sectionModel = sectionModel(at: section) else {
            return 0
        }
        
        return sectionModel.rows.count
    }
    
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
