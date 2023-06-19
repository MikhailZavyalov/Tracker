import UIKit

final class PickerFlowLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let answer = super.layoutAttributesForElements(in: rect) else { return nil }
        for i in 1..<answer.count {
            let currentLayoutAttributes = answer[i]
            let prevLayoutAttributes = answer[i - 1]
            let maximumSpacing: CGFloat = 5
            let origin = prevLayoutAttributes.frame.maxX
            
            if origin + maximumSpacing + currentLayoutAttributes.frame.size.width < collectionViewContentSize.width {
                var frame = currentLayoutAttributes.frame
                frame.origin.x = origin + maximumSpacing
                currentLayoutAttributes.frame = frame
            }
        }
        return answer
    }
}
