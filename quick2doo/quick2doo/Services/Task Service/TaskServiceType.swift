//
//  TaskServiceType.swift
//  quick2doo
//
//  Created by Joan Disho on 09.10.17.
//  Copyright © 2017 Joan Disho. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift

protocol TaskServiceType {
    @discardableResult func createTask(title: String) -> Observable<TaskItem>
    @discardableResult func update(task: TaskItem, title: String) -> Observable<TaskItem>
    @discardableResult func delete(task: TaskItem) -> Observable<TaskItem>
    @discardableResult func toggle(task: TaskItem) -> Observable<TaskItem>
    func tasks() -> Observable<Results<TaskItem>>
}
