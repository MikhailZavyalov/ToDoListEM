
import UIKit

extension UITableViewCell {
    static var reuseID: String {
        String(describing: self)
    }
}
