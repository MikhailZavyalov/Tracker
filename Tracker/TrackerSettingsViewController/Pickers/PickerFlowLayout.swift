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

//- (NSArray *) layoutAttributesForElementsInRect:(CGRect)rect {
//    NSArray *answer = [super layoutAttributesForElementsInRect:rect];
//
//    for(int i = 1; i < [answer count]; ++i) {
//        UICollectionViewLayoutAttributes *currentLayoutAttributes = answer[i];
//        UICollectionViewLayoutAttributes *prevLayoutAttributes = answer[i - 1];
//        NSInteger maximumSpacing = 4;
//        NSInteger origin = CGRectGetMaxX(prevLayoutAttributes.frame);
//
//        if(origin + maximumSpacing + currentLayoutAttributes.frame.size.width < self.collectionViewContentSize.width) {
//            CGRect frame = currentLayoutAttributes.frame;
//            frame.origin.x = origin + maximumSpacing;
//            currentLayoutAttributes.frame = frame;
//        }
//    }
//    return answer;
//}
