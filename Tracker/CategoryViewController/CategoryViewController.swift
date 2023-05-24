import UIKit
import SwiftUI

final class CategoryViewController: UIViewController {
    var onUserDidSelectCategory: ((String) -> Void)?
    
    private var allCategories: [CategoryCellModel] = []
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "Категория"
        label.textColor = .black
        label.backgroundColor = .white
        label.textAlignment = .center
        return label
    }()
    
    let categoriesTableView: UITableView = {
        let tableView = UITableView()
        tableView.layer.cornerRadius = 30
        
        return tableView
    }()
    
    let addCategoryButton: UIButton = {
        let button = UIButton()
        button.setTitle("Добавить категорию", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.heightAnchor.constraint(equalToConstant: 80).isActive = true
        button.layer.cornerRadius = 20
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        allCategories = Storage.trackerCategories.map {
            CategoryCellModel(title: $0.name, isSelected: false)
        }
        
        categoriesTableView.dataSource = self
        categoriesTableView.delegate = self
        categoriesTableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: CategoryTableViewCell.reuseID)
        addCategoryButton.addTarget(self, action: #selector(addCategory), for: .touchUpInside)
        view.backgroundColor = .white
        
        setupConstraints()
    }
    
    func setupConstraints() {
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(categoriesTableView)
        categoriesTableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(addCategoryButton)
        addCategoryButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            categoriesTableView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 30),
            categoriesTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            categoriesTableView.bottomAnchor.constraint(equalTo: addCategoryButton.topAnchor, constant: -20),
            categoriesTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            addCategoryButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            addCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            addCategoryButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
        ])
    }
    
    @objc func addCategory() {
        let viewController = NewCategoryViewController()
        viewController.onUserDidAddNewCategory = { [weak self] categoryTitle in
            guard let self = self else { return }
            viewController.dismiss(animated: true)
            
            for i in 0..<self.allCategories.count {
                self.allCategories[i].isSelected = false
            }
            
            self.allCategories.append(CategoryCellModel(title: categoryTitle, isSelected: true))
            Storage.trackerCategories.append(TrackerCategory(name: categoryTitle, trackers: []))
            self.categoriesTableView.reloadData()
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
        settingsCell.configure(with: allCategories[indexPath.row])
        settingsCell.backgroundColor = .lightGray
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
