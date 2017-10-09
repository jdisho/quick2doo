//
//  Scene.swift
//  quick2doo
//
//  Created by Joan Disho on 09.10.17.
//  Copyright © 2017 Joan Disho. All rights reserved.
//

import Foundation

/**
     Refers to a screen managed by a view controller.
     It can be a regular screen, or a modal dialog.
     It comprises a view controller and a view model.
*/

enum Scene {
    case initialView(ViewModel)
}

extension Scene {
    func viewController() -> ViewController {
        switch self {
        case .initialView(let viewModel):
            var vc = ViewController.instantiateFromNib()
            vc.bind(to: viewModel)
            return vc
        }
    }
}
