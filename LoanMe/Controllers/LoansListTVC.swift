
import UIKit
import Firebase

class LoansListTVC: UITableViewController {
    
    
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
            FirestoreService.shared.delete(transactions[indexPath.row], in: .loanList)
        }
    }

    //MARK: - Database Methods
    
    func loadData() {
        FirestoreService.shared.read(from: .loanList, returning: Transaction.self) { (loanTransactions) in
            self.transactions = loanTransactions
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let transactionDetailTVC = segue.destination as? TransactionDetailTVC else {return}
        if let indexPath = tableView.indexPathForSelectedRow,
            segue.identifier == PropertyKeys.editTransactionSegueIdentifier {
            let transaction = transactions[indexPath.row]
            transactionDetailTVC.transaction = transaction
            transactionDetailTVC.transactionType = transaction.loanType
            transactionDetailTVC.isEditingEntry = true
        }
    }
    
    @IBAction func unwindSegue(_  segue: UIStoryboardSegue) {
        guard let transactionDetailTVC = segue.source as? TransactionDetailTVC else {return}
        
        tableView.reloadData()
    }
    
}
