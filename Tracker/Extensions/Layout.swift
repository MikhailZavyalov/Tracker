import UIKit

extension UIView {
    func pin(to view: UIView, edges: UIRectEdge = .all, insets: UIEdgeInsets = .zero) {
        var constraints: [NSLayoutConstraint] = []
        if edges.contains(.top) {
            constraints.append(topAnchor.constraint(equalTo: view.topAnchor, constant: insets.top))
        }
        if edges.contains(.left) {
            constraints.append(leftAnchor.constraint(equalTo: view.leftAnchor, constant: insets.left))
        }
        if edges.contains(.bottom) {
            constraints.append(bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -insets.bottom))
        }
        if edges.contains(.right) {
            constraints.append(rightAnchor.constraint(equalTo: view.rightAnchor, constant: -insets.right))
        }
        NSLayoutConstraint.activate(constraints)
    }
    
    func pin(to layoutGuide: UILayoutGuide, edges: UIRectEdge = .all, insets: UIEdgeInsets = .zero) {
        var constraints: [NSLayoutConstraint] = []
        if edges.contains(.top) {
            constraints.append(topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: insets.top))
        }
        if edges.contains(.left) {
            constraints.append(leftAnchor.constraint(equalTo: layoutGuide.leftAnchor, constant: insets.left))
        }
        if edges.contains(.bottom) {
            constraints.append(bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor, constant: -insets.bottom))
        }
        if edges.contains(.right) {
            constraints.append(rightAnchor.constraint(equalTo: layoutGuide.rightAnchor, constant: -insets.right))
        }
        NSLayoutConstraint.activate(constraints)
    }
    
    func centerHorizontallyInContainer(offset: CGFloat = 0) {
        guard let superview = superview else { return }

        centerXAnchor.constraint(equalTo: superview.centerXAnchor, constant: offset).isActive = true
    }
    
    func centerVerticallyInContainer(offset: CGFloat = 0) {
        guard let superview = superview else { return }

        centerYAnchor.constraint(equalTo: superview.centerYAnchor, constant: offset).isActive = true
    }
    
    func constrainWidth(_ toWidth: CGFloat) {
        widthAnchor.constraint(equalToConstant: toWidth).isActive = true
    }
    
    func constrainHeight(_ toHeight: CGFloat) {
        heightAnchor.constraint(equalToConstant: toHeight).isActive = true
    }
    
    func constrainSize(_ toSize: CGSize) {
        constrainWidth(toSize.width)
        constrainHeight(toSize.height)
    }
}

extension CGSize {
    static func square(_ dimensions: CGFloat) -> CGSize {
        CGSize(width: dimensions, height: dimensions)
    }
}

extension UIEdgeInsets {
    static func all(_ value: CGFloat) -> UIEdgeInsets {
        UIEdgeInsets(top: value, left: value, bottom: value, right: value)
    }

    static func horizontal(_ value: CGFloat) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: value, bottom: 0, right: value)
    }

    static func vertical(_ value: CGFloat) -> UIEdgeInsets {
        UIEdgeInsets(top: value, left: 0, bottom: value, right: 0)
    }

    static func top(_ value: CGFloat) -> UIEdgeInsets {
        UIEdgeInsets(top: value, left: 0, bottom: 0, right: 0)
    }

    static func left(_ value: CGFloat) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: value, bottom: 0, right: 0)
    }

    static func bottom(_ value: CGFloat) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 0, bottom: value, right: 0)
    }

    static func right(_ value: CGFloat) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 0, bottom: 0, right: value)
    }
}
