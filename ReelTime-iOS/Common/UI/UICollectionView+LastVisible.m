#import "UICollectionView+LastVisible.h"

@implementation UICollectionView (LastVisible)

- (NSInteger)lastVisibleSection {
    return NSNotFound;
}

- (NSInteger)lastVisibleRowForSection:(NSInteger)section {
    return NSNotFound;
}

@end