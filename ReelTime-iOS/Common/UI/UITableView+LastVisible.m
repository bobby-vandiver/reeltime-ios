#import "UITableView+LastVisible.h"

@implementation UITableView (LastVisible)

- (NSInteger)lastVisibleSection {
    NSArray *visiblePaths = [self indexPathsForVisibleRows];
    
    NSIndexPath *lastVisiblePath = [visiblePaths lastObject];
    return lastVisiblePath ? lastVisiblePath.section : NSNotFound;
}

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
    
    return lastVisiblePath ? lastVisiblePath.row : NSNotFound;
}

@end