#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UITableView (LastVisible)

- (NSInteger)lastVisibleRowForSection:(NSInteger)section;

@end