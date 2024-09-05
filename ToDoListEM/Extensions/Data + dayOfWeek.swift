
import Foundation

extension Date {
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE , dd MMM"
        return dateFormatter.string(from: self).capitalized
    }

    func todoTime() -> String? {
        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "EEEE h:mm a - h:mm a"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        return dateFormatter.string(from: self)
    }
}
