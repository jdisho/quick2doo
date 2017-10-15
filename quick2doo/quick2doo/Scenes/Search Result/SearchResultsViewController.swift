//
//  SearchResultsTableViewController.swift
//  quick2doo
//
//  Created by Joan Disho on 14.10.17.
//  Copyright © 2017 Joan Disho. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class SearchResultsViewController: UIViewController, BindableType {
        
    // MARK: ViewModel
    var viewModel: SearchResultsViewModel!
    var dataSource: RxTableViewSectionedAnimatedDataSource<TaskSection>!
    
    // MARK: IBOutlets
    @IBOutlet var tableView: UITableView!
    
    // MARK: Private
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        configureDataSource()
    }
    
    // MARK: BindableType
    
    func bindViewModel() {
        viewModel
            .sections
            .bind(to: self.tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    // MARK: UI
    
    private func configureTableView() {
        tableView.registerCell(type: TaskCell.self)
        tableView.rowHeight = 56
        tableView.sectionHeaderHeight = 48
    }
    
    private func configureDataSource() {
        dataSource = RxTableViewSectionedAnimatedDataSource<TaskSection>()
        dataSource.titleForHeaderInSection = { dataSource, index in 
            dataSource.sectionModels[index].model
        }
        
        dataSource.configureCell = { (dataSource, tableView, indexPath, item) -> TaskCell in
            var cell = tableView.dequeueResuableCell(type: TaskCell.self, forIndexPath: indexPath)
            let cellViewModel = self.viewModel.createTaskCellViewModel(forTask: item)
            cell.bind(to: cellViewModel)
            return cell
        }
        
    }

}
