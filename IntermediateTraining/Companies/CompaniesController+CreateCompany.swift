//
//  CompaniesController+CreateCompany.swift
//  IntermediateTraining
//
//  Created by Arian Azemati on 2018-08-04.
//  Copyright © 2018 Arian Azemati. All rights reserved.
//

import UIKit

extension CompaniesController: CreateCompanyControllerDelegate {
    
    // specify your extension methods here ...
    
    func didEditCompany(company: Company) {
        let row = companies.index(of: company)
        let reloadIndexPath =  IndexPath(row: row!, section: 0)
        tableView.reloadRows(at: [reloadIndexPath], with: .automatic)
    }
    
    func didAddCompany(company: Company) {
        companies.append(company)
        let newIndexPath = IndexPath(row: companies.count - 1 , section: 0)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
    }
    
    
    
}
