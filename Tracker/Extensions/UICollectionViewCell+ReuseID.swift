import UIKit

extension UICollectionViewCell {
    static var reuseID: String {
        String(describing: self)
    }
}

extension UITableViewCell {
    static var reuseID: String {
        String(describing: self)
    }
}
