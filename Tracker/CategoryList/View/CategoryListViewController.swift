import UIKit
import SwiftUI

final class CategoryListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var onUserDidSelectCategory: ((String) -> Void)?

    private let viewModel: CategoryListViewModel
    private var allCategories: [CategoryCellViewModel] {
        viewModel.allCategories
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

    init(viewModel: CategoryListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.$allCategories.bind(executeInitially: true) { [weak self] _ in
            self?.updateUI()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.white
        
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
            viewController.dismiss(animated: true)
            self?.viewModel.addCategory(categoryTitle: categoryTitle)
        }
        present(viewController, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension CategoryListViewController {
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

// MARK: - UITableViewDelegate

extension CategoryListViewController {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onUserDidSelectCategory?(allCategories[indexPath.row].title)
        viewModel.userDidSelectCategory(categoryTitle: allCategories[indexPath.row].title)
    }
}

struct CategoryViewController_Previews: PreviewProvider {
    static var previews: some View {
        let model = CategoryListModel()
        let viewModel = CategoryListViewModel(model: model)
        let vc = CategoryListViewController(viewModel: viewModel)
        
        return UIViewRepresented(makeUIView: { _ in vc.view })
    }
}
