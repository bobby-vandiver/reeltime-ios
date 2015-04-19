#import <UIKit/UIKit.h>

@interface UICollectionView (LastVisible)

- (NSInteger)lastVisibleSection;

- (NSInteger)lastVisibleRowForSection:(NSInteger)section;

@end