import UIKit

final class StatsView: UIView {
    var titleNumber: Int {
        didSet {
            titleLabel.text = "\(titleNumber)"
        }
    }
    var subtitle: String {
        didSet {
            subtitleLabel.text = subtitle
        }
    }

    override var intrinsicContentSize: CGSize {
        CGSize(width: 0, height: 12 * 2 + 1 * 2 + titleLabel.intrinsicContentSize.height + 8 + subtitleLabel.intrinsicContentSize.height)
    }

    private let foregroundView = UIView()
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = Colors.black
        titleLabel.font = .systemFont(ofSize: 34, weight: .bold)
        return titleLabel
    }()

    private let subtitleLabel: UILabel = {
        let subtitleLabel = UILabel()
        subtitleLabel.textColor = Colors.black
        subtitleLabel.font = .systemFont(ofSize: 12, weight: .medium)
        return subtitleLabel
    }()

    private let gradientLayer: CALayer = {
        let gradient = CAGradientLayer()
        let colors = [
            UIColor(red: 253 / 255, green: 76 / 255, blue: 73 / 255, alpha: 1),
            UIColor(red: 70 / 255, green: 230 / 255, blue: 157 / 255, alpha: 1),
            UIColor(red: 0 / 255, green: 123 / 255, blue: 250 / 255, alpha: 1),
        ]
        gradient.colors = colors.map { $0.cgColor }
        gradient.startPoint = .zero
        gradient.endPoint = CGPoint(x: 1, y: 0)
        gradient.cornerRadius = 16
        return gradient
    }()

    init(titleNumber: Int = 0, subtitle: String = "") {
        self.titleNumber = titleNumber
        self.subtitle = subtitle
        super.init(frame: .zero)

        layer.addSublayer(gradientLayer)

        addSubview(foregroundView)
        foregroundView.translatesAutoresizingMaskIntoConstraints = false
        foregroundView.backgroundColor = Colors.white
        foregroundView.layer.cornerRadius = 15

        foregroundView.pin(to: self, edges: .all, insets: .all(1))

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "\(titleNumber)"
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.text = subtitle

        let vStack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        vStack.translatesAutoresizingMaskIntoConstraints = false
        vStack.axis = .vertical
        vStack.alignment = .leading
        vStack.spacing = 8

        foregroundView.addSubview(vStack)
        vStack.centerVerticallyInContainer()
        vStack.pin(to: foregroundView, edges: .left, insets: .left(12))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
}
