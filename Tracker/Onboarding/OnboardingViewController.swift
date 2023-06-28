import UIKit

final class OnboardingViewController: UIViewController {
    var text: String? {
        didSet {
            textLabel.text = text
        }
    }

    var numberOfPages = 0 {
        didSet {
            pageControl.numberOfPages = numberOfPages
        }
    }

    var currentPage = 0 {
        didSet {
            pageControl.currentPage = currentPage
        }
    }

    var backgroundImage: UIImage? {
        didSet {
            backgroundImageView.image = backgroundImage
        }
    }

    var onUserTapButton: (() -> Void)?

    private let finishButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = Colors.black
        button.constrainHeight(60)
        button.layer.cornerRadius = 16
        button.setAttributedTitle(
            NSAttributedString(
                string: "Вот это технологии!",
                attributes: [
                    .font: UIFont.systemFont(ofSize: 16, weight: .medium),
                    .foregroundColor: Colors.white
                ]
            ),
            for: .normal
        )
        return button
    }()
    
    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = Colors.black
        pageControl.pageIndicatorTintColor = Colors.gray
        return pageControl
    }()

    private let textLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textColor = Colors.black
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()

        finishButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }

    private func setupConstraints() {
        view.addSubview(backgroundImageView)
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.pin(to: view)

        view.addSubview(finishButton)
        finishButton.translatesAutoresizingMaskIntoConstraints = false
        finishButton.pin(to: view.safeAreaLayoutGuide, edges: [.left, .bottom, .right], insets: UIEdgeInsets(top: 0, left: 20, bottom: 84, right: 20))

        view.addSubview(pageControl)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.centerHorizontallyInContainer()
        pageControl.bottomAnchor.constraint(equalTo: finishButton.topAnchor, constant: -24).isActive = true

        view.addSubview(textLabel)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.bottomAnchor.constraint(equalTo: pageControl.topAnchor, constant: -130).isActive = true
        textLabel.pin(to: backgroundImageView, edges: [.left, .right], insets: .horizontal(16))
    }

    @objc
    private func buttonTapped() {
        onUserTapButton?()
    }
}
