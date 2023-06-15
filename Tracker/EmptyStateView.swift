import UIKit

final class EmptyStateView: UIView {
    var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }
    var text: String? {
        didSet {
            textLabel.text = text
        }
    }
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        return imageView
    }()
    
    private let textLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.numberOfLines = 0
        textLabel.widthAnchor.constraint(equalToConstant: 250).isActive = true
        textLabel.font = UIFont(name: "SF Pro", size: 12)
        textLabel.textAlignment = .center
        return textLabel
    }()
    
    init() {
        super .init(frame: .zero)
        let vStack = UIStackView(arrangedSubviews: [imageView, textLabel])
        vStack.translatesAutoresizingMaskIntoConstraints = false
        vStack.axis = .vertical
        vStack.alignment = .center
        vStack.spacing = 8
        addSubview(vStack)
        NSLayoutConstraint.activate([
            vStack.topAnchor.constraint(equalTo: topAnchor),
            vStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            vStack.bottomAnchor.constraint(equalTo: bottomAnchor),
            vStack.leadingAnchor.constraint(equalTo: leadingAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
