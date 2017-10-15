//
//  SearchResultsViewModel.swift
//  quick2doo
//
//  Created by Joan Disho on 14.10.17.
//  Copyright © 2017 Joan Disho. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

struct SearchResultsViewModel {
    
    // MARK: Input
    let taskService: TaskServiceType
    
    // MARK: Output
    let results: Observable<[TaskItem]>
    let sections: Observable<[TaskSection]>
    
    init(taskService: TaskServiceType = TaskService(), searchString: Variable<String?>) {
        self.taskService = taskService
        results = taskService.search(withString: searchString)
        sections = results
            .map { tasks -> [TaskSection] in
            let dueTasks = tasks.filter { $0.checked == nil }.sorted(by: { $0.0.added < $0.1.added })
            let doneTasks = tasks.filter { $0.checked != nil }.sorted(by: { $0.0.added < $0.1.added })
            return [
                TaskSection(model: TaskType.due.rawValue, items: dueTasks),
                TaskSection(model: TaskType.done.rawValue, items: doneTasks)
            ]
        }
    }
    
    // MARK: View Models
    func createTaskCellViewModel(forTask task: TaskItem) -> TaskCellViewModel {
        return TaskCellViewModel(taskService: taskService, task: task)
    }

}
