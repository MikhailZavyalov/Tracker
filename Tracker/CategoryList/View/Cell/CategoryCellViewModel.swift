final class CategoryCellViewModel {
    let title: String

    @Observable
    var isSelected: Bool

    init(title: String, isSelected: Bool) {
        self.title = title
        self.isSelected = isSelected
    }
}
