//
//  MainScreenPresenter.swift
//  HW22-CoreData
//
//  Created by Илья on 13.01.2023.
//

import Foundation

protocol MainPresenterProtocol: AnyObject {
    func fetchPersons()
    func numberOfPersons() -> Int
    func addPerson(withName name: String)
    func getPersonName(for index: IndexPath) -> String
    func deletePerson(index: IndexPath)
    func showDetail(forUser index: IndexPath)
    var person: [Person]? { get set }
    init(view: MainViewProtocol, router: RouterProtocol)
}

class MainScreen: MainPresenterProtocol {
    var model = ModelData()
    var person: [Person]?
    weak var view: MainViewProtocol?
    var router: RouterProtocol?
    
    required init(view: MainViewProtocol, router: RouterProtocol) {
        self.view = view
        self.router = router
    }
    
    func fetchPersons() {
        person = model.getPersons().reversed()
        view?.reloadTable()
    }
    
    func numberOfPersons() -> Int {
        person?.count ?? 0
    }
    
    func addPerson(withName name: String) {
        model.addPerson(name: name)
        fetchPersons()
    }
    
    func getPersonName(for index: IndexPath) -> String {
        return person?[index.row].name ?? ""
    }
    
    func deletePerson(index: IndexPath) {
        guard let user = person?[index.row] else { return }
        model.deletePerson(person: user)
        fetchPersons()
    }
    
    func showDetail(forUser index: IndexPath) {
        guard let user = person?[index.row] else { return }
        router?.showDetail(user: user)
    }
}

