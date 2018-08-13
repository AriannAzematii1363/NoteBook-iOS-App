//
//  ViewController.swift
//  IntermediateTraining
//
//  Created by Arian Azemati on 2018-07-30.
//  Copyright © 2018 Arian Azemati. All rights reserved.
//

import UIKit
import  CoreData

class CompaniesController: UITableViewController {
    
    var companies = [Company]() // empty array

  
    
//    private func fetchCompanies() {
//        let context = CoreDataManager.shared.persistentContainer.viewContext
//        let fetchRequest = NSFetchRequest<Company>(entityName: "Company")
//
//
//        do {
//          let companies =  try context.fetch(fetchRequest)
//            companies.forEach { (company) in
//                print(company.name ?? "")
//            }
//
//            self.companies = companies
//            self.tableView.reloadData()
//        }catch let fetchErr {
//          print("failed to fetch comaopny", fetchErr)
//        }
//    }
    
    
    
    @objc private func doWork() {
        print("Trying to do work....")
        
        //GCD Grand Central Dispatch
        
    
            
         CoreDataManager.shared.persistentContainer.performBackgroundTask({ (backgroundContext) in
                (0...5).forEach { (value) in
                    print(value)
                    let company = Company(context:backgroundContext)
                    company.name = String(value)
                    
                }
                do {
                    try backgroundContext.save()
                    
                    
                    
                    DispatchQueue.main.async {
                         self.companies = CoreDataManager.shared.fetchCompanies()
                      self.tableView.reloadData()
                        
                    }
                }catch let err {
                    print("Failed to save",err)
                }
            })
            
            //Creating some company on background thread
            //let context = CoreDataManager.shared.persistentContainer.viewContext
    }
    
    
    
    //Lets do some tricky updates with core data
    
    
    
    @ objc private func doUpdates() {
  print("TRYING TO UPDATES COMPANIES ON A BACKGROUND CONTEXT")
        
        CoreDataManager.shared.persistentContainer.performBackgroundTask { (backgroundContext) in
            
            
            let request : NSFetchRequest<Company> = Company.fetchRequest()
            
            do{
         let companies = try backgroundContext.fetch(request)
                companies.forEach({ (company) in
                    print(company.name ?? "")
                    company.name = "c: \(company.name ?? "")"
                })
                do{
                   try backgroundContext.save()
                    
                    // let's try update the ui after the save
                    
                    DispatchQueue.main.async {
                        
                        
                        //reset will forrget all your object you've fetch before
                        //and fetching the companies and emploies is an expensive task
                        
                        CoreDataManager.shared.persistentContainer.viewContext.reset()
                        
                        //you dont wanna refresh everything if you're just simply update one or two companies
                        self.companies = CoreDataManager.shared.fetchCompanies()
                        
                        //is there a way to just merge the changes that you made on the main view contex
                        self.tableView.reloadData()
                    }
                    
                }catch let err {
                    print("Failed to save on background",err)
                }
               
            }catch let err {
                print("Failed to fetch comoanies on background",err)
            }
           
        }
    }
    
    
    
    @objc private func doNestedUpdates() {
        print("trying to perform nested update")
        
        DispatchQueue.global(qos: .background).async {
            //we will trying to perform our updates
            
            //we'll first construct a custom Manage object context
            let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            privateContext.parent = CoreDataManager.shared.persistentContainer.viewContext
            
            //execute updates on private context now
            
            let request : NSFetchRequest<Company> = Company.fetchRequest()
            request.fetchLimit = 1
            do {
                let companies = try  privateContext.fetch(request)
                
                companies.forEach({ (company) in
                    print(company.name ?? "")
                    company.name = "D: \(company.name ?? "")"
                })
                
                do{
                    try privateContext.save()
                    
                    DispatchQueue.main.sync {
                        
                        do{
                            
                            let context = CoreDataManager.shared.persistentContainer.viewContext
                            
                            if context.hasChanges {
                                try context.save()
                               
                            }
                             self.tableView.reloadData()
                           
                        }catch let finalSaveErr {
                            print("Faile to save tmain Context", finalSaveErr)
                        }
                       
                    }
                }catch let err {
                    print("Failed to save on private context", err)
                }
                
                
            }catch let err{
                print("Failed to fectch on private context",err)
            }
            
        }
    }
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.companies = CoreDataManager.shared.fetchCompanies()
  // fetchCompanies()
//**add        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target:
//            self, action: #selector(handleReset))
        
        //****pak:
        navigationItem.leftBarButtonItems = [UIBarButtonItem(title: "Reset", style: .plain, target:
            self, action: #selector(handleReset)), UIBarButtonItem(title: "Nested Updates", style: .plain, target:
                self, action: #selector(doNestedUpdates))
        ]
        
         view.backgroundColor = .white
        navigationItem.title = "Companies"
        
        tableView.separatorColor = .white
        
        tableView.backgroundColor = .darkBlue
       // tableView.separatorStyle = .none
        tableView.tableFooterView = UIView() // blank UIView
        tableView.register(CompanyCell.self, forCellReuseIdentifier: "cellId")
        
        setupPlusButtonInNavBar(selector: #selector(handleAddCompany))
//        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus").withRenderingMode(.alwaysOriginal) , style: .plain, target: self, action: #selector(handleAddCompany))
    
    }
    
    @ objc private func handleReset() {
        
        
        CoreDataManager.shared.resetCompanies {
            var indexPathToRemove = [IndexPath]()
            for (index, _ ) in self.companies.enumerated() {
                let indexPath = IndexPath(row: index, section: 0)
                indexPathToRemove.append(indexPath)
            }
            companies.removeAll()
            tableView.deleteRows(at: indexPathToRemove, with: .left)
        }
//        print("Attempting to do batch request and deleting all core data objects")
//
//        let context = CoreDataManager.shared.persistentContainer.viewContext
////        companies.forEach { (company) in
////            context.delete(company)
////
////        }
//
//       let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: Company.fetchRequest())
//
//        do {
//            try context.execute(batchDeleteRequest)
//
//            //upon deletion from core data succeded
//
//            var indexPathToRemove = [IndexPath]()
//
//
//            for(index, _) in companies.enumerated() {
//               let indexPath = IndexPath(row: index, section: 0)
//                indexPathToRemove.append(indexPath)
//            }
//                companies.removeAll()
//               tableView.deleteRows(at: indexPathToRemove, with: .left)
////            companies.forEach { (company) in
////                companies.index(of: company)
////                //but this loop doesnot provide us with row number
////            }
////
////           companies.removeAll()
////            tableView.reloadData()
//
//        }catch let delErr {
//            print("Failed to delete objects from core data",delErr)
//        }
    }
    

    
   @objc func handleAddCompany() {
        print("Adding Company")
    
    
    let createCompanyController = CreateCompanyController()
    //createCompanyController.view.backgroundColor = .green
    let navController = CustomNavigationController(rootViewController: createCompanyController)
    
    createCompanyController.delegate = self
    present(navController, animated: true, completion: nil)
    
    
    }
    
}
