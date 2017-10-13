//
//  ViewModel.swift
//  quick2doo
//
//  Created by Joan Disho on 09.10.17.
//  Copyright © 2017 Joan Disho. All rights reserved.
//

import RxSwift
import RxCocoa
import RxDataSources

/** 
     View model: Defines the business logic and data 
     used by the view controller to present a particular scene.
 */

enum TaskType: String {
    case due = "Due tasks"
    case done = "Done tasks"
}

typealias TaskSection = AnimatableSectionModel<String, TaskItem>

struct TasksViewModel {
    
    // MARK: Input
    private let sceneCoordinator: SceneCoordinatorType
    private let taskService: TaskServiceType
    
    init(sceneCoordinator: SceneCoordinatorType = SceneCoordinator.shared, taskService: TaskServiceType = TaskService()) {
        self.sceneCoordinator = sceneCoordinator
        self.taskService = taskService
    }
    
    var sections: Observable<[TaskSection]> {
        return taskService.tasks()
        .map { results in
            let dueTasks = results.filter("checked == nil").sorted(byKeyPath: "added", ascending: false)
            let doneTasks = results.filter("checked != nil").sorted(byKeyPath: "added", ascending: false)
            return [
                TaskSection(model: TaskType.due.rawValue, items: dueTasks.toArray()),
                TaskSection(model: TaskType.done.rawValue, items: doneTasks.toArray())
            ]
        }
    }
    
    // MARK: Create ViewModel
    func createTaskCellViewModel(forTask task: TaskItem) -> TaskCellViewModel {
        return TaskCellViewModel(taskService: taskService, task: task)
    }
}
