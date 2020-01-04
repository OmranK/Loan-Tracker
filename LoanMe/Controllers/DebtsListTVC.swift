//
//  DebtsListTVC.swift
//  EmployeeRoster
//
//  Created by Omran Khoja on 1/3/20.
//

import Foundation
import UIKit
import Firebase

class DebtsListTVC: UITableViewController {
    
    //MARK: - Properties
    struct PropertyKeys {
        static let transactionIdentifier = "TransactionCell"
        static let addTransactionSegueIdenifier = "AddTransactionSegue"
        static let editTransactionSegueIdentifier = "EditTransactionSegue"
    }
    
    var transactions: [Transaction] = []
    
    //MARK: - VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        guard let navBar = navigationController?.navigationBar else {fatalError("NavBar does not exist.")}
        navBar.tintColor = UIColor.white
    }
    
    // MARK: TableView Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PropertyKeys.transactionIdentifier, for: indexPath)
        
        let transaction = transactions[indexPath.row]
        cell.textLabel?.text = transaction.name
        cell.detailTextLabel?.text = "\(transaction.loanType.description()): $\(transaction.loanAmount)"
        
        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            FirestoreService.shared.delete(transactions[indexPath.row], in: .debtList)
        }
    }

    //MARK: - Database Methods
    
    func loadData() {
        FirestoreService.shared.read(from: .debtList, returning: Transaction.self) { (debtTransactions) in
            self.transactions = debtTransactions
            self.tableView.reloadData()
        }
    }
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let transactionDetailTVC = segue.destination as? TransactionDetailTVC else {return}
        if let indexPath = tableView.indexPathForSelectedRow,
            segue.identifier == PropertyKeys.editTransactionSegueIdentifier {
            transactionDetailTVC.transaction = transactions[indexPath.row]
        }
    }
    
    @IBAction func unwindSegue(_  segue: UIStoryboardSegue) {
        guard let transactionDetailTVC = segue.source as? TransactionDetailTVC else {return}
        tableView.reloadData()
    }
}
