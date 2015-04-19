#import <UIKit/UIKit.h>

@interface UITableView (LastVisible)

- (NSInteger)lastVisibleSection;

- (NSInteger)lastVisibleRowForSection:(NSInteger)section;

@end