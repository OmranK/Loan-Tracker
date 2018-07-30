
import UIKit

class TransactionDetailTVC: UITableViewController, UITextFieldDelegate, TransactionTypeDelegate {

    struct PropertyKeys {
        static let unwindToListIndentifier = "UnwindToListSegue"
    }
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var dateOfLoanLabel: UILabel!
    @IBOutlet weak var transactionTypeLabel: UILabel!
    @IBOutlet weak var loanDatePicker: UIDatePicker!
    @IBOutlet weak var loanAmountTextField: UITextField!
    
    
    var transaction: Transaction?
    var loanType: TransactionType?
    var loanAmount: Int?
    
    var isEditingLoanDate: Bool = false {
        didSet {
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    let dateRow = 2
    let datePickerRow = 3
    let defaultHeight : CGFloat = 44
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
        self.loanDatePicker.setValue(UIColor.white, forKey: "textColor")
    }
    
    func updateView() {
        if let transaction = transaction {
            navigationItem.title = transaction.name
            nameTextField.text = transaction.name
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateOfLoanLabel.text = dateFormatter.string(from: transaction.dateOfLoan)
            dateOfLoanLabel.textColor = .white
            transactionTypeLabel.text = transaction.loanType.description()
            transactionTypeLabel.textColor = .white
        } else {
            navigationItem.title = "New Loan"
        }
    }
    
    
    // Table View
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard indexPath.row == datePickerRow else { return defaultHeight }
        if isEditingLoanDate {
            return 216.0
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == dateRow {
            isEditingLoanDate = !isEditingLoanDate
            dateOfLoanLabel.textColor = .white
            dateOfLoanLabel.text = formatDate(date: loanDatePicker.date)
        }
    }
    
    // MARK: - Helper methods.
    
    func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from:date)
    }
    
    func didSelect(transactionType: TransactionType) {
        self.loanType = transactionType
        transactionTypeLabel.text = transactionType.description()
        transactionTypeLabel.textColor = .white
    }
    
    
    
    // MARK: - Text Field Delegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
    
    
    // MARK: IBActions
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        if let name = nameTextField.text, let type = loanType {
            transaction = Transaction(name: name, dateOfLoan: loanDatePicker.date, loanType: type , loanAmount: Int(loanAmountTextField.text!) ?? 0)
            performSegue(withIdentifier: PropertyKeys.unwindToListIndentifier, sender: self)
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        transaction = nil
        performSegue(withIdentifier: PropertyKeys.unwindToListIndentifier, sender: self)
    }
    
    @IBAction func datePicketValueChanged(_ sender: Any) {
        dateOfLoanLabel.text = formatDate(date: loanDatePicker.date)
    }

    
    // MARK: Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let transactionTypeTVC = segue.destination as? TransactionTypeTVC else { return }
        transactionTypeTVC.transactionType = transaction?.loanType
        transactionTypeTVC.transactionTypeDelegate = self
    }
}



