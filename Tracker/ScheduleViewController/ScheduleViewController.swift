import UIKit
import SwiftUI

final class ScheduleViewController: UIViewController {
    private let weekDays: [ScheduleCellModel] = [
        ScheduleCellModel(title: "Понедельник", switchValue: false),
        ScheduleCellModel(title: "Вторник", switchValue: false),
        ScheduleCellModel(title: "Среда", switchValue: false),
        ScheduleCellModel(title: "Четверг", switchValue: false),
        ScheduleCellModel(title: "Пятница", switchValue: false),
        ScheduleCellModel(title: "Суббота", switchValue: false),
        ScheduleCellModel(title: "Воскресенье", switchValue: false)
    ]
    
    let scheduleLable: UILabel = {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scheduleTableView.dataSource = self
        scheduleTableView.delegate = self
        scheduleTableView.register(ScheduleTableViewCell.self, forCellReuseIdentifier: ScheduleTableViewCell.reuseID)
        scheduleDoneButton.addTarget(self, action: #selector(scheduleDoneButtonTapped), for: .touchUpInside)
        view.backgroundColor = .white
        setupConstraints()
    }
    
    private func setupConstraints() {
        view.addSubview(scheduleLable)
        scheduleLable.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scheduleTableView)
        scheduleTableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(scheduleDoneButton)
        scheduleDoneButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scheduleLable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            scheduleLable.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            scheduleTableView.topAnchor.constraint(equalTo: scheduleLable.bottomAnchor, constant: 30),
            scheduleTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            scheduleTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            scheduleTableView.bottomAnchor.constraint(equalTo: scheduleDoneButton.topAnchor, constant: -20),
            scheduleDoneButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            scheduleDoneButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            scheduleDoneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
        ])
    }
    
    @objc private func scheduleDoneButtonTapped() {
        dismiss(animated: true)
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
        return oneDayCell
    }
}

extension ScheduleViewController: UITableViewDelegate {
    
}

struct ScheduleViewController_Previews: PreviewProvider {
  static var previews: some View {
    let vc = ScheduleViewController()
      
    return UIViewRepresented(makeUIView: { _ in vc.view })
  }
}

