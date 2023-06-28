import UIKit
import SwiftUI

final class StatisticsViewController: UIViewController {
    private let separator: UIView = {
        let separator = UIView()
        separator.backgroundColor = Colors.lightGray
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return separator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.white
        title = "StatisticsVC.title".localized

        constrConf()
    }
    
    func constrConf() {
        view.addSubview(separator)
        NSLayoutConstraint.activate([
            separator.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            separator.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            separator.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
        ])
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

struct StatisticsViewController_Previews: PreviewProvider {
    static var previews: some View {
        let vc = StatisticsViewController()
        
        return UIViewRepresented(makeUIView: { _ in vc.view })
    }
}
