//
//  EditTaskViewModel.swift
//  quick2doo
//
//  Created by Joan Disho on 13.10.17.
//  Copyright © 2017 Joan Disho. All rights reserved.
//

import RxSwift
import Action

struct EditTaskViewModel {
    
    // MARK: Input
    let sceneCoordinator: SceneCoordinatorType
    let taskService: TaskServiceType
    let task: TaskItem
    let taskDescription = Variable<String>("")
    
    // MARK Private
    private let disposeBag = DisposeBag()
    
    init(sceneCoordinator: SceneCoordinatorType = SceneCoordinator.shared, taskService: TaskServiceType = TaskService(), task: TaskItem) {
        self.sceneCoordinator = sceneCoordinator
        self.taskService = taskService
        self.task = task
        self.taskDescription.value = task.title
    }
    
    // MARK: Actions
    
    func onUpdateButtonAction() -> CocoaAction { 
        return CocoaAction {
            self.taskService.update(task: self.task, title: self.taskDescription.value)
            return self.sceneCoordinator.pop(animated: true)
        }
    }
    
    lazy var onCancelButtonAction: CocoaAction = {
        let sceneCoordinator = self.sceneCoordinator
        return CocoaAction {
            sceneCoordinator.pop(animated: true)
        }
    }()
    
}
