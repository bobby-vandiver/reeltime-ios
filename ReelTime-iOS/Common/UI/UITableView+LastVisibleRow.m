#import "UITableView+LastVisibleRow.h"

@implementation UITableView (LastVisibleRow)

// TODO: Add test
- (NSInteger)lastVisibleRowForSection:(NSInteger)section {
    NSArray *visiblePaths = [self indexPathsForVisibleRows];

    if (!visiblePaths) {
        return NSNotFound;
    }
    
    NSPredicate *sectionFilter = [NSPredicate predicateWithBlock:^BOOL(NSIndexPath *path, NSDictionary *bindings) {
        return path.section == section;
    }];
    
    NSArray *visiblePathsForSection = [visiblePaths filteredArrayUsingPredicate:sectionFilter];
    NSIndexPath *lastVisiblePath = [visiblePathsForSection lastObject];

    return lastVisiblePath.row;
}

@end