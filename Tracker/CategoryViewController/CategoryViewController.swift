import UIKit
import SwiftUI

final class CategoryViewController: UIViewController {
    var onUserDidSelectCategory: ((String) -> Void)?
    var selectedCategory: String?
    
    private var allCategories: [CategoryCellModel] = [] {
        didSet {
            updateUI()
        }
    }
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "Категория"
        label.font = UIFont(name: "SF Pro", size: 16)
        label.textColor = Colors.black
        label.textAlignment = .center
        return label
    }()
    
    private let categoriesTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private let addCategoryButton: UIButton = {
        let button = UIButton()
        button.setTitle("Добавить категорию", for: .normal)
        button.setTitleColor(Colors.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "SF Pro", size: 16)
        button.backgroundColor = Colors.black
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        button.layer.cornerRadius = 16
        return button
    }()
    
    private let emptyStateView: EmptyStateView = {
        let view = EmptyStateView()
        view.image = UIImage(named: "trackersIsEmptyLogo")
        view.text = "Привычки и события можно объединить по смыслу"
        return view
    }()
    
    private var observation: NSKeyValueObservation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.white
        observation = CoreDataStorage.shared.observe(
            \.trackerCategories,
             options: [.initial]
        ) { [weak self] storage, _ in
            self?.allCategories = storage.trackerCategories.map {
                CategoryCellModel(title: $0.name, isSelected: $0.name == self?.selectedCategory)
            }
        }
        
        categoriesTableView.dataSource = self
        categoriesTableView.delegate = self
        categoriesTableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: CategoryTableViewCell.reuseID)
        addCategoryButton.addTarget(self, action: #selector(addCategory), for: .touchUpInside)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(categoriesTableView)
        categoriesTableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(addCategoryButton)
        addCategoryButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(emptyStateView)
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 27),
            categoriesTableView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 24),
            categoriesTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            categoriesTableView.bottomAnchor.constraint(equalTo: addCategoryButton.topAnchor, constant: -20),
            categoriesTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            addCategoryButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            addCategoryButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            addCategoryButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            emptyStateView.centerXAnchor.constraint(equalTo: categoriesTableView.centerXAnchor),
            emptyStateView.centerYAnchor.constraint(equalTo: categoriesTableView.centerYAnchor),
        ])
    }
    
    private func updateUI() {
        categoriesTableView.reloadData()
        emptyStateView.isHidden = !allCategories.isEmpty
    }
    
    @objc func addCategory() {
        let viewController = NewCategoryViewController()
        viewController.onUserDidAddNewCategory = { [weak self] categoryTitle in
            guard let self = self else { return }
            defer { self.updateUI() }
            
            viewController.dismiss(animated: true)
            
            for i in 0..<self.allCategories.count {
                self.allCategories[i].isSelected = false
            }
            
            if let existingCategoryIndex = self.allCategories.firstIndex(where: { $0.title == categoryTitle }) {
                self.allCategories[existingCategoryIndex].isSelected = true
                return
            }
            
            self.selectedCategory = categoryTitle
            try! CoreDataStorage.shared.add(trackerCategory: TrackerCategory(name: categoryTitle, trackers: []))
        }
        present(viewController, animated: true)
    }
}

extension CategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.reuseID, for: indexPath)
        guard let settingsCell = cell as? CategoryTableViewCell else { return cell }
        settingsCell.configure(
            with: allCategories[indexPath.row],
            isFirst: indexPath.row == 0,
            isLast: indexPath.row == allCategories.count - 1
        )
        return settingsCell
    }
}

extension CategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onUserDidSelectCategory?(allCategories[indexPath.row].title)
    }
}

struct CategoryViewController_Previews: PreviewProvider {
    static var previews: some View {
        let vc = CategoryViewController()
        
        return UIViewRepresented(makeUIView: { _ in vc.view })
    }
}
