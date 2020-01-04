//
//  EmployeeTypeTableViewController.swift
//  EmployeeRoster
//
//  Created by Omran Khoja on 2/19/18.
//

import UIKit

protocol TransactionTypeDelegate {
    func didSelect(transactionType: TransactionType)
}

class TransactionTypeTVC: UITableViewController {
    
    struct PropertyKeys {
        static let transactionTypeCell = "TransactionTypeCell"
    }
    
    var transactionType: TransactionType?
    var transactionTypeDelegate: TransactionTypeDelegate?
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TransactionType.all.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PropertyKeys.transactionTypeCell, for: indexPath)
        let type = TransactionType.all[indexPath.row]
        cell.textLabel?.text = type.description()
        
        if transactionType == type {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        transactionType = TransactionType.all[indexPath.row]
        transactionTypeDelegate?.didSelect(transactionType: transactionType!)
        tableView.reloadData()
    }
    
}
