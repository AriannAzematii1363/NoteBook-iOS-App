//
//  CoreDataManager.swift
//  IntermediateTraining
//
//  Created by Arian Azemati on 2018-07-31.
//  Copyright © 2018 Arian Azemati. All rights reserved.
//

import CoreData

struct CoreDataManager {
    
    static let shared = CoreDataManager() //This Variable will Live forever  as long as your application still alive,and it's properties will
    
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name:
            "IntermediateTrainingModels")
        container.loadPersistentStores { (storeDescription, err) in
            if let err = err {
                fatalError("Loading of store failed: \(err)")
            }
        }
        return container
    }()
    
    func fetchCompanies() -> [Company] {
            let context = persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<Company>(entityName: "Company")
       
            
            do {
                let companies =  try context.fetch(fetchRequest)
                
                return companies
//                companies.forEach { (company) in
//                    print(company.name ?? "")
//                }
                
            }catch let fetchErr {
                print("failed to fetch comaopny", fetchErr)
                return []
            }
        }
    
    func resetCompanies(completion: () -> ()) {
        
        let context = persistentContainer.viewContext
        let deleteBatchRequest = NSBatchDeleteRequest(fetchRequest: Company.fetchRequest())

        
        do{
           try context.execute(deleteBatchRequest)
            completion()
        }catch let err {
            print("unable to delete batch companies", err)
        }
    }
    
    func createEmployee(employeeName: String,employeeType: String, birthday: Date, company: Company) -> (Employee?, Error?) {
        let context = persistentContainer.viewContext
        
        //create an Employee
        let employee = NSEntityDescription.insertNewObject(forEntityName: "Employee", into: context) as! Employee
        
        // lets check Company is set up correctly
        
//        let company = Company(context: context)
//        
        employee.company = company
        
        employee.setValue(employeeName, forKey: "name")
        employee.type = employeeType
        
        let employeeInformation = NSEntityDescription.insertNewObject(forEntityName: "EmployeeInformation", into: context) as! EmployeeInformation
        
        //now after we cast the employyeInformation to be as EmployeeInformationwe can call the property on that and asign the valuue for it directly
        employeeInformation.taxId = "456"
        
        employeeInformation.birthday = birthday
      //  employeeInformation.setValue("456", forKey: "taxId")
        
        employee.employeeInformation = employeeInformation
        
        
        do {
            try context.save()
            //If Save Succeed
        
            return (employee, nil)
        } catch let err {
            print("Failed to creat Employee", err)
            return(nil,err)
        }
    }
    
}







