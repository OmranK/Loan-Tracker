
import Foundation

enum TransactionType {
    case loaned
    case borrowed
    
    static let all: [TransactionType] = [.loaned, .borrowed]
    
    func description() -> String {
        switch self {
        case .loaned:
            return "Loaned Me"
        case .borrowed:
            return "Borrowed"
        }
    }
}

struct Transaction {
    var name: String
    var dateOfLoan: Date
    var loanType: TransactionType
    var loanAmount: Int
    
}
