import UIKit
import SwiftUI

final class ScheduleViewController: UIViewController {
    var onUserDidSelectSchedule: ((Set<Tracker.WeekDay>) -> Void)?
    
    private var weekDays: [ScheduleCellModel]
    
    let scheduleLabel: UILabel = {
        let label = UILabel()
        label.text = "Расписание"
        return label
    }()
    
    let scheduleTableView: UITableView = {
        let tableView = UITableView()
        tableView.layer.cornerRadius = 20
        return tableView
    }()
    
    let scheduleDoneButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.layer.cornerRadius = 20
        button.heightAnchor.constraint(equalToConstant: 80).isActive = true
        button.setTitle("Готово", for: .normal)
        return button
    }()
    
    init(enabledWeekDays: Set<Tracker.WeekDay> = Set()) {
        weekDays = Tracker.WeekDay.allCases.map {
            ScheduleCellModel(dayOfWeek: $0, switchValue: enabledWeekDays.contains($0))
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scheduleTableView.dataSource = self
        scheduleTableView.register(ScheduleTableViewCell.self, forCellReuseIdentifier: ScheduleTableViewCell.reuseID)
        scheduleDoneButton.addTarget(self, action: #selector(scheduleDoneButtonTapped), for: .touchUpInside)
        view.backgroundColor = .white
        setupConstraints()
    }
    
    private func setupConstraints() {
        view.addSubview(scheduleLabel)
        scheduleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scheduleTableView)
        scheduleTableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scheduleDoneButton)
        scheduleDoneButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scheduleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            scheduleLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            scheduleTableView.topAnchor.constraint(equalTo: scheduleLabel.bottomAnchor, constant: 30),
            scheduleTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            scheduleTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            scheduleTableView.bottomAnchor.constraint(equalTo: scheduleDoneButton.topAnchor, constant: -20),
            scheduleDoneButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            scheduleDoneButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            scheduleDoneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
        ])
    }
    
    @objc private func scheduleDoneButtonTapped() {
        let enabledDays = weekDays.filter {
            $0.switchValue
        }.map {
            $0.dayOfWeek
        }
        
        onUserDidSelectSchedule?(Set(enabledDays))
    }
}

extension ScheduleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weekDays.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ScheduleTableViewCell.reuseID, for: indexPath)
        guard let oneDayCell = cell as? ScheduleTableViewCell else { return cell }
        oneDayCell.configure(with: weekDays[indexPath.row])
        oneDayCell.onValueChanged = { [self] switchValue in
            weekDays[indexPath.row].switchValue = switchValue
        }
        return oneDayCell
    }
}

struct ScheduleViewController_Previews: PreviewProvider {
    static var previews: some View {
        let vc = ScheduleViewController()
        
        return UIViewRepresented(makeUIView: { _ in vc.view })
    }
}

