//
//  DetailViewController.swift
//  HW22-CoreData
//
//  Created by Илья on 13.01.2023.
//

import UIKit
import SnapKit

protocol DetailViewProtocol: AnyObject {
    func setupDetailedView(name: String?, dateOfBirth: String?, gender: String?, image: Data?)
}

class DetailViewController: UIViewController {
    private var isEdit = false
    var presenter: DetailPresenter?
    private var genders = ["", "Мужской", "Женский", "Неизвестен"]
    
    // MARK: - Elements
    
    lazy var mainImagePerson: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: Strings.DetailViewController.mainImagePerson)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 75
        return imageView
    }()
    
    lazy var iconNameImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: Strings.DetailViewController.iconNameImage)
        return image
    }()
    
    lazy var textNamePerson: UITextField = {
        let text = UITextField()
        text.isEnabled = false
        text.placeholder = Strings.DetailViewController.textNamePersonPlaceholder
        return text
    }()
    
    lazy var iconDateBirth: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: Strings.DetailViewController.iconDateBirth)
        return image
    }()
    
    lazy var textDateOfBirth: UITextField = {
        let text = UITextField()
        text.isEnabled = false
        text.placeholder = Strings.DetailViewController.textDateOfBirthPlaceholder
        return text
    }()
    
    lazy var iconGender: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: Strings.DetailViewController.iconGender)
        return image
    }()
    
    lazy var textGender: UITextField = {
        let text = UITextField()
        text.isEnabled = false
        text.placeholder = Strings.DetailViewController.textGenderPlaceholder
        return text
    }()
    
    lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.isHidden = true
        let datePickerPreferredSize = datePicker.systemLayoutSizeFitting(view.bounds.size)
        datePicker.addTarget(self, action: #selector(doneAction), for: .valueChanged)
        return datePicker
    }()
    
    
    lazy var genderPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        picker.isHidden = true
        return picker
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: Strings.DetailViewController.navigationButtonEdit, style: .plain, target: self, action: #selector(editTapped))
        setupHierarchy()
        setupLayout()
        presenter?.setUpParametersPerson()
    }
    
    // MARK: - Setup
    
    private func setupHierarchy() {
        view.addSubview(mainImagePerson)
        view.addSubview(iconNameImage)
        view.addSubview(textNamePerson)
        view.addSubview(iconDateBirth)
        view.addSubview(textDateOfBirth)
        view.addSubview(iconGender)
        view.addSubview(textGender)
        view.addSubview(datePicker)
        view.addSubview(genderPicker)
    }
    
    private func setupLayout() {
        
        mainImagePerson.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(view).offset(150)
            make.height.width.equalTo(150)
        }
        
        iconNameImage.snp.makeConstraints { make in
            make.top.equalTo(mainImagePerson.snp.bottom).offset(50)
            make.left.equalTo(view).offset(30)
            make.height.equalTo(30)
            make.width.equalTo(30)
        }
        
        textNamePerson.snp.makeConstraints { make in
            make.top.equalTo(mainImagePerson.snp.bottom).offset(50)
            make.left.equalTo(iconNameImage.snp.right).offset(15)
            make.height.equalTo(30)
            make.width.equalTo(180)
        }
        
        iconDateBirth.snp.makeConstraints { make in
            make.top.equalTo(iconNameImage.snp.bottom).offset(60)
            make.left.equalTo(view).offset(30)
            make.height.equalTo(30)
            make.width.equalTo(30)
        }
        
        textDateOfBirth.snp.makeConstraints { make in
            make.top.equalTo(iconNameImage.snp.bottom).offset(60)
            make.left.equalTo(iconNameImage.snp.right).offset(15)
            make.height.equalTo(30)
            make.width.equalTo(180)
        }
        
        iconGender.snp.makeConstraints { make in
            make.top.equalTo(iconDateBirth.snp.bottom).offset(60)
            make.left.equalTo(view).offset(30)
            make.height.equalTo(30)
            make.width.equalTo(30)
        }
        
        textGender.snp.makeConstraints { make in
            make.top.equalTo(textDateOfBirth.snp.bottom).offset(60)
            make.left.equalTo(iconGender.snp.right).offset(15)
            make.height.equalTo(30)
            make.width.equalTo(180)
        }
        
        datePicker.snp.makeConstraints { make in
            make.top.equalTo(iconNameImage.snp.bottom).offset(60)
            make.left.equalTo(iconNameImage.snp.right).offset(15)
            make.height.equalTo(30)
        }
        
        genderPicker.snp.makeConstraints { make in
            make.top.equalTo(datePicker.snp.bottom).offset(25)
            make.left.equalTo(iconGender.snp.right).offset(5)
            make.height.equalTo(100)
            make.width.equalTo(190)
        }
    }
    
    // MARK: - Actions Button
    
    @objc func editTapped() {
        isEdit.toggle()
        if isEdit {
            navigationItem.rightBarButtonItem?.title = Strings.DetailViewController.navigationButtonSave
            navigationItem.rightBarButtonItem?.tintColor = .systemGreen
            
            textNamePerson.isEnabled = true
            textDateOfBirth.isHidden = true
            textGender.isHidden = true
            
            textNamePerson.backgroundColor = .systemGray6
            textDateOfBirth.backgroundColor = .systemGray6
            textGender.backgroundColor = .systemGray6
            
            datePicker.isHidden = false
            genderPicker.isHidden = false
        } else {
            let name = textNamePerson.text
            let date = textDateOfBirth.text
            let gender = textGender.text
            let image = mainImagePerson.image?.pngData()
            
            presenter?.updateParametersPerson(name: name, dateOfBirth: date, gender: gender, image: image)
            
            navigationItem.rightBarButtonItem?.title = Strings.DetailViewController.navigationButtonEdit
            navigationItem.rightBarButtonItem?.tintColor = .systemBlue
            
            textNamePerson.isEnabled = false
            textDateOfBirth.isEnabled = false
            textDateOfBirth.isHidden = false
            textGender.isHidden = false
            
            textNamePerson.backgroundColor = .white
            textDateOfBirth.backgroundColor = .white
            textGender.backgroundColor = .white
            
            datePicker.isHidden = true
            genderPicker.isHidden = true
        }
    }
    
    @objc func doneAction() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Strings.DetailViewController.dateFormat
        self.textDateOfBirth.text = dateFormatter.string(from: datePicker.date)
        view.endEditing(true)
    }
}

     // MARK: - Extensions

extension DetailViewController: DetailViewProtocol {
    func setupDetailedView(name: String?, dateOfBirth: String?, gender: String?, image: Data?) {
        if let imageData = image {
            mainImagePerson.image = UIImage(data: imageData)
        }
        textNamePerson.text = name
        textDateOfBirth.text = dateOfBirth
        textGender.text = gender
    }
}

     // MARK: - Extensions UIPickerViewDelegate, UIPickerViewDataSource

extension DetailViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        genders.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        genders[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textGender.text = genders[row]
    }
}
