
import Foundation

extension Date {
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE , dd MMM"
        return dateFormatter.string(from: self).capitalized
    }
}
