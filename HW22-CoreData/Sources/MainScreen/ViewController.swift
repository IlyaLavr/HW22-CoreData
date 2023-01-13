//
//  ViewController.swift
//  HW22-CoreData
//
//  Created by Илья on 13.01.2023.
//

import UIKit
import CoreData
import SnapKit

protocol MainViewProtocol: AnyObject {
    func reloadTable()
}

class ViewController: UIViewController, MainViewProtocol {
    
    var presenter: MainPresenterProtocol?
    
    // MARK: - Elements
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.textColor = .black
        textField.backgroundColor = .lightGray
        textField.textAlignment = .center
        textField.placeholder = Strings.ViewController.textFieldPlaceholder
        textField.isHighlighted = true
        textField.layer.cornerRadius = 20
        return textField
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.setTitle(Strings.ViewController.addButtonText, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .medium)
        button.layer.cornerRadius = 17
        button.addTarget(self, action: #selector(addPerson), for: .touchDown)
        return button
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.backgroundColor = .white
        tableView.tintColor = .blue
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.identifier)
        return tableView
    }()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title =  Strings.ViewController.navigationTitle
        navigationController?.navigationBar.prefersLargeTitles = true
        setupHierarhy()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        presenter?.fetchPersons()
    }
    
    // MARK: - Setup
    
    private func setupHierarhy() {
        view.addSubview(textField)
        view.addSubview(button)
        view.addSubview(tableView)
    }
    
    private func setupLayout() {
        
        textField.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).offset(160)
            make.left.equalTo(view.snp.left).offset(10)
            make.right.equalTo(view.snp.right).offset(-10)
            make.height.equalTo(70)
        }
        
        button.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(15)
            make.left.equalTo(view.snp.left).offset(10)
            make.right.equalTo(view.snp.right).offset(-10)
            make.height.equalTo(70)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(button.snp.bottom).offset(30)
            make.left.right.equalTo(view)
            make.bottom.equalTo(view)
        }
    }
    
    @objc func addPerson() {
        if let userName = textField.text, userName != "" {
            presenter?.addPerson(withName: userName)
            textField.text = ""
        }
    }
    
    func reloadTable() {
        tableView.reloadData()
    }
}

     // MARK: - Extension UITableViewDataSource

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = presenter?.getPersonName(for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.numberOfPersons() ?? 0
    }
}

// MARK: - Extension UITableViewDelegate

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter?.showDetail(forUser: indexPath)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            presenter?.deletePerson(index: indexPath)
        }
    }
}

