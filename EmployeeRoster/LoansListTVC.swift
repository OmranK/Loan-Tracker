
import UIKit

class LoansListTVC: UITableViewController {

    struct PropertyKeys {
        static let transactionIdentifier = "TransactionCell"
        static let addTransactionSegueIdenifier = "AddTransactionSegue"
        static let editTransactionSegueIdentifier = "EditTransactionSegue"
    }
    
    var transactions: [Transaction] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        guard let navBar = navigationController?.navigationBar else {fatalError("NavBar does not exist.")}
        navBar.tintColor = UIColor.white
    }
    
    // MARK: Table view data source
    
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
            transactions.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
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
        guard let transactionDetailTVC = segue.source as? TransactionDetailTVC,
            let transaction = transactionDetailTVC.transaction else {return}
        if let indexPath = tableView.indexPathForSelectedRow {
            transactions.remove(at: indexPath.row)
            transactions.insert(transaction, at: indexPath.row)
        } else {
            transactions.append(transaction)
        }
    }

}
