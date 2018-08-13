//
//  EmployeesController.swift
//  IntermediateTraining
//
//  Created by Arian Azemati on 2018-08-04.
//  Copyright © 2018 Arian Azemati. All rights reserved.
//

import UIKit
import CoreData

// lets creat a UILabel subclass for custom text drawing

class IndentedLabel: UILabel {
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        let customRect = UIEdgeInsetsInsetRect(rect, insets)
        super.drawText(in: customRect)
    }
    

}

class EmployeesController: UITableViewController, CreateEmployeeControllerDelegate  {
    
//    func didEditEmployee(employee: [[Employee]]) {
//        let row = employees.index(of: employee)
//        let indexPath = IndexPath(row: row!, section: 0)
//        tableView.reloadRows(at: [indexPath], with: .automatic)
//    }
//
    
  

    
    func didAddEmployee(employee: Employee) {
        fetchEmployees()
       // employees.append(employee)
//        let indexPath = IndexPath(row: employees.count - 1, section: 0)
//        tableView.insertRows(at: [indexPath], with: .automatic)
        tableView.reloadData()
    }
    
    
    
    var company: Company?
 //   var employees = [Employee]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = company?.name
    }

    
//    var shortNameEmployees = [Employee]()
//
//    var longNameEmployees = [Employee]()
//
//    var reallyLongNameEmployees = [Employee]()
//
    var allEmployees = [[Employee]]()
    
    var employeeTypes = [
        EmployeeType.Executive.rawValue,
        EmployeeType.SeniorManagement.rawValue,
        EmployeeType.Staff.rawValue,
        EmployeeType.Intern.rawValue
         ]
    
    private func fetchEmployees() {
        
        guard let companyEmployees = company?.employees?.allObjects as? [Employee] else {return}
       // var allEmployees = [[Employee]]()
       // let's use my array and loop to filter instead
        allEmployees = []
        employeeTypes.forEach { (employeeType) in
            // someHow construct my AllEmployees array
            allEmployees.append(
                companyEmployees.filter{ $0.type == employeeType}
            )
        }
        
        
        /*
        lets filter employees for  "Ececutives"
//    */
//        let executives = companyEmployees.filter { (employee) -> Bool in
//            return employee.type == EmployeeType.Executive.rawValue
//        }
//        
//        let seniorMaanagment = companyEmployees.filter{ return $0.type == EmployeeType.SeniorManagement.rawValue}
//       
//        allEmployees = [
//            executives,
//            seniorMaanagment,
//            companyEmployees.filter{$0.type == EmployeeType.Staff.rawValue}
//        ]
        
        //we want to apply a filte on companyEmployees
//
//        let shortNameEmployees =  companyEmployees.filter({ (employee) -> Bool in
//            if let count = employee.name?.count {
//                return count < 5
//            }
//            return false
//        })
//
//        longNameEmployees = companyEmployees.filter({ (employee) -> Bool in
//            if let count = employee.name?.count {
//                return count > 6 && count < 9
//            }
//            return false
//        })
//
//
//
//        reallyLongNameEmployees = companyEmployees.filter({ (employee) -> Bool in
//            if let count = employee.name?.count {
//                return count > 9
//            }
//            return false
//        })
        
        
        
//        allEmployees = [
//            shortNameEmployees,
//            longNameEmployees,
//            reallyLongNameEmployees
//        ]
        
//        print(shortNameEmployees.count, longNameEmployees.count, reallyLongNameEmployees.count)
        
       // self.employees = companyEmployees
//        print("trying to fetch empployyes")
//
//        let context = CoreDataManager.shared.persistentContainer.viewContext
//        let request = NSFetchRequest<Employee>(entityName: "Employee")
//
//        do {
//           let employees = try context.fetch(request)
//            self.employees = employees
////            tableView.reloadData()
//       //     employees.forEach{print("Employees Name:", $0.name ?? "")}
//        }catch let err {
//            print("failed to fetch employee",err)
//        }
    }
    
    
    
  
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = IndentedLabel()
//        if section == 0 {
//            label.text = EmployeeType.Executive.rawValue
//        } else if section == 1 {
//            label.text = EmployeeType.SeniorManagement.rawValue
//        } else {
//            label.text = EmployeeType.Staff.rawValue
//        }
        
        label.text = employeeTypes[section]
        
        label.textColor = .darkBlue
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.backgroundColor = .lightBlue
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return allEmployees.count
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return allEmployees[section].count
//        if section == 0 {
//            return shortNameEmployees.count
//        }
//        return longNameEmployees.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
//        if indexPath.section == 0 {
//            employee = shorName
//        }
        
//        // I will use a turnary  operator
//
//        let employee = employees[indexPath.row]
        
        
//        let employee = indexPath.section == 0 ? shortNameEmployees[indexPath.row] : longNameEmployees[indexPath.row]
        
        let employee = allEmployees[indexPath.section][indexPath.row]
        
        cell.textLabel?.text = employee.name
        
        if let birthday = employee.employeeInformation?.birthday {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy"
            cell.textLabel?.text = "\(employee.name ?? "")   \(dateFormatter.string(from: birthday))" 
        }
        
//        if let taxId = employee.employeeInformation?.taxId {
//            cell.textLabel?.text = "\(employee.name ?? "")   \(taxId) "
//        }
        
        cell.backgroundColor = .tealColor
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        return cell
        
    }
    
    let cellId = "celllllllllId"
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .darkBlue
        tableView.separatorStyle = .none
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
       
        setupPlusButtonInNavBar(selector: #selector(handleAdd))
        fetchEmployees()
    }
    
    @objc private func handleAdd() {
        print("trying to add an employee")
        let createEmployeeController = CreateEmployeeController()
        createEmployeeController.delegate = self
        createEmployeeController.company = self.company
        let navController = UINavigationController(rootViewController: createEmployeeController)
        
        present(navController, animated: true, completion: nil)
    }
    
    
//    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (_, indexPath) in
//           
//            let employee = self.employees[indexPath.row]
//          
//            
//            self.employees.remove(at: indexPath.row)
//            self.tableView.deleteRows(at: [indexPath], with: .automatic)
//            
//            let context = CoreDataManager.shared.persistentContainer.viewContext
//            context.delete(employee)
//            print("attempting to delet employee")
//            do{
//                try context.save()
//            }catch let err {
//                print("cant delet",err)
//            }
//            
//        }
//        deleteAction.backgroundColor = UIColor.lightRed
//        let editAction = UITableViewRowAction(style: .normal, title: "Edit", handler: editHandlerFunction)
//        editAction.backgroundColor = UIColor.darkBlue
//        return [deleteAction, editAction]
//    }
//    
//    func editHandlerFunction(action: UITableViewRowAction, indexPath: IndexPath) {
//        let editEmployeeController = CreateEmployeeController()
//        editEmployeeController.employee = employees[indexPath.row]
//        editEmployeeController.delegate = self
//        editEmployeeController.company = company
//        let navController = UINavigationController(rootViewController: editEmployeeController)
//        present(navController, animated: true)
//        
//    }
    
   
    
    
}
