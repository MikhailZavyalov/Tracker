import UIKit

final class OnboardingContainer: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    var onFinish: (() -> Void)?

    private let pages: [OnboardingViewController] = {
        [
            makeOnboardingPage(text: "Отслеживайте только то, что хотите", page: 0, total: 2),
            makeOnboardingPage(text: "Даже если это не литры воды и йога", page: 1, total: 2)
        ]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self

        pages.forEach {
            $0.onUserTapButton = { [weak self] in
                self?.onFinish?()
            }
        }
        
        if let first = pages.first {
            setViewControllers([first], direction: .forward, animated: true, completion: nil)
        }
    }
    
    
    // MARK: - UIPageViewControllerDataSource

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = (pages as [UIViewController]).firstIndex(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1

        guard previousIndex >= 0 else {
            return nil
        }
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = (pages as [UIViewController]).firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1

        guard nextIndex < pages.count else {
            return nil
        }
        
        return pages[nextIndex]
    }
    
    // MARK: - UIPageViewControllerDelegate

    static func makeOnboardingPage(text: String, page: Int, total: Int) -> OnboardingViewController {
        let onboardingVC = OnboardingViewController()
        onboardingVC.text = text
        onboardingVC.numberOfPages = total
        onboardingVC.currentPage = page
        onboardingVC.backgroundImage = UIImage(named: "onboardingPage\(page)")
        return onboardingVC
    }
}
