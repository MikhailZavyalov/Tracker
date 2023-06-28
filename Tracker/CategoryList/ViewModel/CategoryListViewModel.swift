import UIKit

final class CategoryListViewModel {
    @Observable
    var allCategories: [CategoryCellViewModel] = []
    var selectedCategory: String? {
        set {
            _selectedCategory = newValue

            if let selectedIndex = allCategories.firstIndex(where: { $0.isSelected }) {
                allCategories[selectedIndex].isSelected = false
            }

            if let newValue,
               let existingCategoryIndex = allCategories.firstIndex(where: { $0.title == newValue })
            {
                allCategories[existingCategoryIndex].isSelected = true
            }
        }
        get {
            _selectedCategory
        }
    }
    private var _selectedCategory: String?

    private let model: CategoryListModel

    init(model: CategoryListModel) {
        self.model = model
        model.$allCategories.bind(executeInitially: true) { [weak self] trackerCategories in
            self?.allCategories = trackerCategories.map {
                CategoryCellViewModel(title: $0.name, isSelected: $0.name == self?.selectedCategory)
            }
        }
    }

    func addCategory(categoryTitle: String) {
        selectedCategory = categoryTitle

        if allCategories.contains(where: { $0.title == categoryTitle }) {
            return
        }

        model.addCategory(categoryTitle: categoryTitle)
    }

    func userDidSelectCategory(categoryTitle: String) {
        selectedCategory = categoryTitle
    }
}
