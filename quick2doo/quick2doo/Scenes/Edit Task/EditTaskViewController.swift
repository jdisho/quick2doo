//
//  EditTaskViewController.swift
//  quick2doo
//
//  Created by Joan Disho on 13.10.17.
//  Copyright © 2017 Joan Disho. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class EditTaskViewController: UIViewController, BindableType {

    // MARK: ViewModel
    var viewModel: EditTaskViewModel!
    
    // MARK: IBOutlet
    @IBOutlet var taskDescriptionTextView: UITextView!
    
    // MARK: Private
    private var updateBarButton: UIBarButtonItem!
    private var cancelBarButton: UIBarButtonItem!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Edit ✏️"
        addBarButtonItems()
    }
    
    //MARK: BindableType
    
    func bindViewModel() {
        viewModel.taskDescription.asObservable().bind(to: taskDescriptionTextView.rx.text).disposed(by: disposeBag)
        taskDescriptionTextView.rx.text.orEmpty.bind(to: viewModel.taskDescription).disposed(by: disposeBag)
        
        updateBarButton.rx.action = viewModel.onUpdateButtonAction()
        cancelBarButton.rx.action = viewModel.onCancelButtonAction
    }
    
    // MARK: UI
    
    private func addBarButtonItems()  {
        updateBarButton = UIBarButtonItem(title: "OK", style: .plain, target: self, action: nil)
        cancelBarButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: nil)
        
        self.navigationItem.leftBarButtonItem = updateBarButton
        self.navigationItem.rightBarButtonItem = cancelBarButton
    }

}
