//
//  TasksViewController.swift
//  quick2doo
//
//  Created by Joan Disho on 09.10.17.
//  Copyright © 2017 Joan Disho. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class TasksViewController: UIViewController, BindableType {

    // MARK: ViewModel
    var viewModel: TasksViewModel!
    
    // MARK: IBOutlets
    @IBOutlet var tableView: UITableView!
    
    // MARK: Private
    private let disposeBag = DisposeBag()
    private var dataSource: RxTableViewSectionedAnimatedDataSource<TaskSection>!
    private var addNewNoteBarButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setEditing(true, animated: true)
        configureNavigationBar()
        addBarButtonItems()
        configureDataSource()
        configureTableView()
    }

    // MARK: BindableType
    
    func bindViewModel() {
        viewModel
            .sections
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .map { [unowned self] indexPath in
                try! self.dataSource.model(at: indexPath) as! TaskItem
            }
            .subscribe(viewModel.onEditTask.inputs)
            .disposed(by: disposeBag)
        
        tableView.rx.itemDeleted
            .map { [unowned self] indexPath in
                try! self.dataSource.model(at: indexPath) as! TaskItem
            }
            .subscribe(viewModel.onDeleteTask.inputs)
            .disposed(by: disposeBag)
        
        addNewNoteBarButton.rx.action = viewModel.onCreateTask
    }
    
    // MARK: UI
    
    private func addBarButtonItems()  {
        addNewNoteBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
        self.navigationItem.rightBarButtonItem = addNewNoteBarButton
    }
    
    private func configureTableView() {
        tableView.registerCell(type: TaskCell.self)
        tableView.rowHeight = 56
        tableView.sectionHeaderHeight = 48
    }
    
    private func configureNavigationBar() {
        title = "Tasks 📝"
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        } else {
            // Fallback on earlier versions
        }
    }
    
    // MARK: DataSource
    
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
        
        dataSource.canEditRowAtIndexPath = { _ in true }
    }
    
}
