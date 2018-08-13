//
//  CompaniesAutoUpdateController.swift
//  IntermediateTraining
//
//  Created by Arian Azemati on 2018-08-12.
//  Copyright © 2018 Arian Azemati. All rights reserved.
//

import UIKit
import CoreData


class CompaniesAutoUpdateController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    //Warning this code here is going to be a bit monster
    
    
    lazy var fetchResultsController: NSFetchedResultsController<Company> = {
        
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        let request : NSFetchRequest<Company> = Company.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(key: "name", ascending: true)
        ]
        
        let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: "name", cacheName: nil)
        
        frc.delegate = self
        
        do {
            try  frc.performFetch()
        }catch let err {
            print(err)
        }
       
        
        return frc
    }()
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        case .move:
            break
        case .update:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, sectionIndexTitleForSectionName sectionName: String) -> String? {
        return sectionName
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    
    @objc private func handleAdd() {
        print("Let's add a company called BMW")
        
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        let company = Company(context: context)
        
        company.name = "BMW"
        
        try? context.save()
    }
    
    @objc private func handleDelete() {
        
        let request: NSFetchRequest<Company> = Company.fetchRequest()
        
        request.predicate = NSPredicate(format: "name CONTAINS %@", "B")
        
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        let companiesWithB = try? context.fetch(request)
        
        
        companiesWithB?.forEach { (company) in
            context.delete(company)
        }
        
        try? context.save()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        navigationItem.title = "Company auto Updates"
        
      //  navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(handleAdd))
        
        navigationItem.leftBarButtonItems = [UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(handleAdd)), UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(handleDelete))]
        
        tableView.backgroundColor = UIColor.darkBlue
        tableView.register(CompanyCell.self, forCellReuseIdentifier: cellId)
        
        fetchResultsController.fetchedObjects?.forEach({ (company) in
            print(company.name ?? "")
        })
        
    }
    
    
    let cellId = "cellId"
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let label = IndentedLabel()
        label.text = fetchResultsController.sectionIndexTitles[section]
        label.backgroundColor = UIColor.lightBlue
        return label
    }
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchResultsController.sections?.count ?? 0
        
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchResultsController.sections![section].numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CompanyCell
        
        
        let company = fetchResultsController.object(at: indexPath)
        cell.company = company
        return cell
    }
    
    
    
    
    
}
