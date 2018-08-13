//
//  CreatEmployeeController.swift
//  IntermediateTraining
//
//  Created by Arian Azemati on 2018-08-04.
//  Copyright © 2018 Arian Azemati. All rights reserved.
//

import UIKit

protocol CreateEmployeeControllerDelegate {
    func didAddEmployee(employee: Employee)
    //func didEditEmployee(employee: Employee)
}

class CreateEmployeeController: UIViewController {
    var delegate: CreateEmployeeControllerDelegate?
    
    var company: Company?
    
//    var employee: Employee? {
//        didSet {
//            nameTextField.text = employee?.name
//        }
//    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        
        //enable AutoLayOut
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Name"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    
    let birthdayLabel: UILabel = {
        let label = UILabel()
        label.text = "Birthday"
        
        //enable AutoLayOut
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    
    let birthdayTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "MMM/DD/YYYY"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        navigationItem.title = employee == nil ? "Create Employee" : "Edit Employee"
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      //  navigationItem.title = "Create Employee"
       setupCancelButton()
        view.backgroundColor = UIColor.darkBlue
        
      
        
        setupUI()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
    }
    
//    @objc func handleSave() {
//        if employee == nil {
//            createEmployee()
//        } else {
//            return
//        }
//    }
    
    @objc func  handleSave() {
      //  print("saving employee")
        
        guard let employeeName = nameTextField.text else {return}
        guard let company = company else {return}
        
        // turn birthday TectField.text  into the Date object
        
        guard let birthdayText =  birthdayTextField.text else {return}
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/DD/YYYY"
        
        guard let birthdayDate = dateFormatter.date(from: birthdayText) else {
            showError(title: "Bad Date", message: "Birthday date entered not valid")
            return
        }
        
        // lets perform the validation(form validation for birthday and name
        if birthdayText.isEmpty {
            showError(title: "Empty Birthday", message: "You have not enter the birthday.")
            return
        }
        
        guard let employeeType = employeeTypeSegmentedControll.titleForSegment(at: employeeTypeSegmentedControll.selectedSegmentIndex) else  {return}
        
        //print(employeeType)
    
        // where do we get tis company from
        
        let tuple = CoreDataManager.shared.createEmployee(employeeName: employeeName, employeeType: employeeType, birthday: birthdayDate, company: company)
        
        
        if let error = tuple.1 {
            
            // is where you  present an error model of some kind
            //perhaps use UIAlertController to show your error message
            print(error)
        }else {
            //creation success
            
            dismiss(animated: true) {
                self.delegate?.didAddEmployee(employee: tuple.0!)
            }
        }
    }
    
    
    private func showError(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
//    private func saveEmployeeChanges() {
//
//        let context = CoreDataManager.shared.persistentContainer.viewContext
//        employee?.name = nameTextField.text
//        employee?.company = self.company
//        do{
//            try context.save()
//        } catch let err {
//            print("edited employee could not be save",err)
//            //present UIAlertController to show error message
//        }
//        dismiss(animated: true) {
//            self.delegate?.didEditEmployee(employee: self.employee!)
//        }
//
//    }
    
    
    let employeeTypeSegmentedControll: UISegmentedControl = {
//        let types =  ["Executive", "Senior Management", "Staff"]
        let types = [EmployeeType.Executive.rawValue, EmployeeType.SeniorManagement.rawValue, EmployeeType.Staff.rawValue, EmployeeType.Intern.rawValue]
        let sc = UISegmentedControl(items: types)
        sc.selectedSegmentIndex = 0
        sc.tintColor = .darkBlue
        sc.translatesAutoresizingMaskIntoConstraints = false
        return sc
    }()
    
    
    
    private func setupUI() {
          _ = setupLightBlueBackgroundView(height: 150)
        
        view.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        // nameLabel.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(nameTextField)
        nameTextField.leftAnchor.constraint(equalTo: nameLabel.rightAnchor).isActive = true
        nameTextField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        nameTextField.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        nameTextField.topAnchor.constraint(equalTo: nameLabel.topAnchor).isActive = true
        
        
        view.addSubview(birthdayLabel)
        birthdayLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        birthdayLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        // nameLabel.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
       birthdayLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        birthdayLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        view.addSubview(birthdayTextField)
        birthdayTextField.leftAnchor.constraint(equalTo: birthdayLabel.rightAnchor).isActive = true
        birthdayTextField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        birthdayTextField.bottomAnchor.constraint(equalTo: birthdayLabel.bottomAnchor).isActive = true
        birthdayTextField.topAnchor.constraint(equalTo: birthdayLabel.topAnchor).isActive = true
        
        view.addSubview(employeeTypeSegmentedControll)
        employeeTypeSegmentedControll.topAnchor.constraint(equalTo: birthdayLabel.bottomAnchor, constant: 0).isActive = true
        employeeTypeSegmentedControll.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        employeeTypeSegmentedControll.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        employeeTypeSegmentedControll.heightAnchor.constraint(equalToConstant: 34).isActive = true
        
        
        
        
        
        
        
        
        
        
    
    }
    
}
