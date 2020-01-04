
import UIKit

class TransactionDetailTVC: UITableViewController, UITextFieldDelegate, UITextViewDelegate, TransactionTypeDelegate {
    
    //MARK: - IBOutlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var dateOfLoanLabel: UILabel!
    @IBOutlet weak var transactionTypeLabel: UILabel!
    @IBOutlet weak var loanDatePicker: UIDatePicker!
    @IBOutlet weak var loanAmountTextField: UITextField!
    @IBOutlet weak var notesTextView: UITextView!
    
  //MARK: - Properties
    struct PropertyKeys {
        static let unwindToListIndentifier = "UnwindToListSegue"
    }
    
    var transaction: Transaction?
    var transactionType: TransactionType?
    var loanAmount: Int?
    var isEditingEntry: Bool = false
    
    let dateRow = 2
    let datePickerRow = 3
    let defaultHeight : CGFloat = 44
    var isEditingLoanDate: Bool = false {
        didSet {
            if isEditingLoanDate == true {
                UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 1, delay: 0, options: [.allowUserInteraction, .curveEaseInOut], animations: {
                    self.tableView.beginUpdates()
                    self.tableView.endUpdates()
                }, completion: nil)
            } else {
                tableView.beginUpdates()
                tableView.endUpdates()
            }
        }
    }
    
    
    
    
    //MARK: - VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
        self.loanDatePicker.setValue(UIColor.white, forKey: "textColor")
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    //MARK: - UI Method
    
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
            notesTextView.text = transaction.notes
            loanAmountTextField.text = "\(transaction.loanAmount)"
        } else {
            navigationItem.title = "New Entry"
        }
    }
    
    //MARK: - Table View Delegate Methods
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 2 {
            return UITableViewAutomaticDimension
        }
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
    
    // MARK: - Helper Methods
    
    func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from:date)
    }
    
    func didSelect(transactionType: TransactionType) {
        self.transactionType = transactionType
        transactionTypeLabel.text = transactionType.description()
        transactionTypeLabel.textColor = .white
    }
    
    
    
    // MARK: - Text Field Delegate Methods
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
    
    func textViewDidChange(_ textView: UITextView) {
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    
    // MARK: IBActions
    
    @IBAction func saveButtonTapped(_ sender: Any) {

        if let name = nameTextField.text, let type = transactionType {
            transaction = Transaction(name: name, dateOfLoan: loanDatePicker.date, loanType: type , loanAmount: Int(loanAmountTextField.text!) ?? 0, notes: notesTextView.text)
            let collectionList: FirestoreCollectionReference = type == .loaned ? .loanList : .debtList
            if isEditingEntry {
                FirestoreService.shared.update(for: transaction!, in: collectionList)
                print("updated")
            } else {
                FirestoreService.shared.createEntry(for: transaction, in: collectionList)
                print("saved")
            }
            
            performSegue(withIdentifier: PropertyKeys.unwindToListIndentifier, sender: self)
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        transaction = nil
        performSegue(withIdentifier: PropertyKeys.unwindToListIndentifier, sender: self)
    }
    
    @IBAction func datePickerValueChanged(_ sender: Any) {
        dateOfLoanLabel.text = formatDate(date: loanDatePicker.date)
    }
    
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let transactionTypeTVC = segue.destination as? TransactionTypeTVC else { return }
        transactionTypeTVC.transactionType = transaction?.loanType
        transactionTypeTVC.transactionTypeDelegate = self
    }
}



