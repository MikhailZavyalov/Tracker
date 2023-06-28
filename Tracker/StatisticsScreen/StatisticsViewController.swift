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

    private let emptyStateView: EmptyStateView = {
        let view = EmptyStateView()
        view.image = UIImage(named: "trackersIsEmptyLogo")
        view.text = "TrackersMainVC.emptyStateView.title".localized
        return view
    }()

    private let storage: CoreDataStorageProtocol = CoreDataStorage.shared
    private var observations: Set<NSKeyValueObservation> = []

    private let completedStatsView = StatsView()

    private var completedTrackersCount = 0 {
        didSet {
            updateUI()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.white
        title = "StatisticsVC.title".localized

        observations.insert(
            storage.observeTrackerRecords { [weak self] records in
                self?.completedTrackersCount = records.count
            }
        )

        setupConstaints()
    }
    
    private func setupConstaints() {
        view.addSubview(separator)

        view.addSubview(emptyStateView)
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false

        let statsStack = UIStackView(arrangedSubviews: [completedStatsView])
        statsStack.axis = .vertical
        statsStack.spacing = 12
        statsStack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(statsStack)

        [completedStatsView].forEach {
            statsStack.widthAnchor.constraint(equalTo: $0.widthAnchor).isActive = true
        }

        NSLayoutConstraint.activate([
            separator.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            separator.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            separator.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),

            emptyStateView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateView.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            statsStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            statsStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            statsStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func updateUI() {
        emptyStateView.isHidden = completedTrackersCount != 0
        completedStatsView.titleNumber = completedTrackersCount
        completedStatsView.subtitle = "Трекеров завершено"
    }
}

struct StatisticsViewController_Previews: PreviewProvider {
    static var previews: some View {
        let vc = StatisticsViewController()
        
        return UIViewRepresented(makeUIView: { _ in vc.view })
    }
}
