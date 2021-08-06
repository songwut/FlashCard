//
//  ViewModelBased.swift
//  flash
//
//  Created by Songwut Maneefun on 3/8/2564 BE.
//

import Foundation
import UIKit

protocol ViewModelBased {
    associatedtype ViewModelType
    
    var viewModel: ViewModelType! { get set }
}


extension ViewModelBased where Self: UIViewController, Self: NibBased {

    // MARK: Static functions

    static func instantiate(viewModel: Self.ViewModelType, storyboard: UIStoryboard? = nil) -> Self {
        var viewController = Self.init(nibName: self.nibName, bundle: Bundle(for: self))
        viewController.viewModel = viewModel
        return viewController
    }

}


