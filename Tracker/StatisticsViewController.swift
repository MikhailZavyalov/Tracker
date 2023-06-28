import UIKit
import SwiftUI

final class StatisticsViewController: UIViewController {
    private let statisticsVCLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Статистика"
        label.textColor = Colors.black
        label.font = .boldSystemFont(ofSize: 34)
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        return label
    }()
    
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
        constrConf()
    }
    
    func constrConf() {
        view.addSubview(statisticsVCLabel)
        view.addSubview(separator)
        NSLayoutConstraint.activate([
            statisticsVCLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 88),
            statisticsVCLabel.heightAnchor.constraint(equalToConstant: 41),
            statisticsVCLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            separator.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            separator.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            separator.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
        ])
    }
}

struct StatisticsViewController_Previews: PreviewProvider {
    static var previews: some View {
        let vc = StatisticsViewController()
        
        return UIViewRepresented(makeUIView: { _ in vc.view })
    }
}
