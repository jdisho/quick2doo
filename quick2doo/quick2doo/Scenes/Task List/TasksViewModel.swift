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
import Action

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
    
    // MARK: Output
    let sections: Observable<[TaskSection]>
    
    init(sceneCoordinator: SceneCoordinatorType = SceneCoordinator.shared, taskService: TaskServiceType = TaskService()) {
        self.sceneCoordinator = sceneCoordinator
        self.taskService = taskService
        
        sections = taskService.tasks()
            .map { results -> [TaskSection] in
                let dueTasks = results.filter("checked == nil").sorted(byKeyPath: "added", ascending: false)
                let doneTasks = results.filter("checked != nil").sorted(byKeyPath: "added", ascending: false)
                return [
                    TaskSection(model: TaskType.due.rawValue, items: dueTasks.toArray()),
                    TaskSection(model: TaskType.done.rawValue, items: doneTasks.toArray())
                ]
            }
        
    }
    
    // MARK: Actions
    
    lazy var onCreateTask: CocoaAction = {
        let sceneCoordinator = self.sceneCoordinator
        let taskService = self.taskService
        return CocoaAction { _ in
            taskService
                .create(task: TaskItem(), title: "")
                .map { task in 
                    sceneCoordinator.transition(to: .editTask(EditTaskViewModel(task: task)), type: .modal)
                }
        }
    }()
    
    lazy var onEditTask: Action<TaskItem, Void> = { 
        let sceneCoordinator = self.sceneCoordinator
        return Action<TaskItem, Void> { task in
            let editTaskViewModel = EditTaskViewModel(task: task)
            return sceneCoordinator.transition(to: .editTask(editTaskViewModel), type: .modal)
        }
    }()
    
    // MARK: Create ViewModel
    
    func createTaskCellViewModel(forTask task: TaskItem) -> TaskCellViewModel {
        return TaskCellViewModel(taskService: taskService, task: task)
    }
    
}
