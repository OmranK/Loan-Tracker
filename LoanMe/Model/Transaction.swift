
import Foundation

protocol FirebaseObject {
    var id: String? { get set }
}

enum TransactionType: String, Codable, CaseIterable {
    case loaned
    case borrowed
    
    static let all: [TransactionType] = [.loaned, .borrowed]
    
    func description() -> String {
        switch self {
        case .loaned:
            return "Borrowed"
        case .borrowed:
            return "Loaned Me"
        }
    }
}

struct Transaction: Codable, FirebaseObject {
    var id: String? = nil
    var name: String
    var dateOfLoan: Date
    var loanType: TransactionType
    var loanAmount: Int
    var notes: String
    
    init(name:String, dateOfLoan: Date, loanType: TransactionType, loanAmount: Int, notes: String) {
        self.name = name
        self.dateOfLoan = dateOfLoan
        self.loanType = loanType
        self.loanAmount = loanAmount
        self.notes = notes
    }
    
}

