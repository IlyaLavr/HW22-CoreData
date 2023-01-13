//
//  DetailPresenter.swift
//  HW22-CoreData
//
//  Created by Илья on 13.01.2023.
//

import Foundation

protocol DetailPresenterProtocol: AnyObject {
    func setUpParametersPerson()
    func updateParametersPerson(name: String?, dateOfBirth: String?, gender: String?, image: Data?)
    
    init(user: Person, view: DetailViewProtocol, router: RouterProtocol)
}

class DetailPresenter: DetailPresenterProtocol {
    var person: Person
    weak var view: DetailViewProtocol?
    var router: RouterProtocol?
    var model: ModelData?
    
    required init(user: Person, view: DetailViewProtocol, router: RouterProtocol) {
        self.person = user
        self.view = view
        self.router = router
    }
    
    func setUpParametersPerson() {
        view?.setupDetailedView(name: person.name, dateOfBirth: person.dateOfBirth, gender: person.gender, image: person.image)
    }
    
    func updateParametersPerson(name: String?, dateOfBirth: String?, gender: String?, image: Data?) {
        person.name = name
        person.dateOfBirth = dateOfBirth
        person.gender = gender
        person.image = image
        person.addDate = Date()
        model?.saveContext()
    }
}


