//
//  ModuleBuilder.swift
//  HW22-CoreData
//
//  Created by Илья on 13.01.2023.
//

import UIKit

protocol BuilderProtocol {
    func createMainModule(router: RouterProtocol) -> UIViewController
    func createDetailModule(user: Person, router: RouterProtocol) -> UIViewController
}

class ModuleBuilder: BuilderProtocol {
    
    func createMainModule(router: RouterProtocol) -> UIViewController {
        let view = ViewController()
        let presenter = MainScreen(view: view, router: router)
        view.presenter = presenter
        return view
    }
    
    func createDetailModule(user: Person, router: RouterProtocol) -> UIViewController {
        let view = DetailViewController()
        let presenter = DetailPresenter(user: user, view: view, router: router)
        view.presenter = presenter
        return view
    }
}

