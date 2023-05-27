import UIKit
import SwiftUI

final class StatisticsViewController: UIViewController {
    let statisticsVCLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Экран статистики"
        label.textColor = .black
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        constrConf()
    }
    
    func constrConf() {
        view.addSubview(statisticsVCLabel)
        NSLayoutConstraint.activate([
            statisticsVCLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            statisticsVCLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            statisticsVCLabel.heightAnchor.constraint(equalToConstant: 60),
            statisticsVCLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 120),
        ])
    }
}

struct StatisticsViewController_Previews: PreviewProvider {
  static var previews: some View {
    let vc = StatisticsViewController()
      
    return UIViewRepresented(makeUIView: { _ in vc.view })
  }
}
