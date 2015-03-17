#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UITableView (LastVisibleRow)

- (NSInteger)lastVisibleRowForSection:(NSInteger)section;

@end