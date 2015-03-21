#import "RTTestCommon.h"

#import "UITableView+LastVisible.h"

@interface TestUITableView : UITableView

@property NSArray *visibleIndexPaths;

@end

@implementation TestUITableView

- (NSArray *)indexPathsForVisibleRows {
    return self.visibleIndexPaths;
}

@end

SpecBegin(UITableView_LastVisible)

describe(@"table view last visible category", ^{
    
    __block TestUITableView *tableView;
    
    beforeEach(^{
        tableView = [[TestUITableView alloc] init];
    });
    
    describe(@"last visible row for section", ^{
        it(@"has no visible paths", ^{
            tableView.visibleIndexPaths = nil;
            
            NSInteger lastRow = [tableView lastVisibleRowForSection:0];
            expect(lastRow).to.equal(NSNotFound);
        });
        
        it(@"has paths but not for the requested section", ^{
            NSIndexPath *r1s0 = [NSIndexPath indexPathForRow:1 inSection:0];
            tableView.visibleIndexPaths = @[r1s0];
            
            NSInteger lastRow = [tableView lastVisibleRowForSection:1];
            expect(lastRow).to.equal(NSNotFound);
        });
        
        it(@"has multiple rows in requested section", ^{
            NSIndexPath *r0s0 = [NSIndexPath indexPathForRow:0 inSection:0];
            NSIndexPath *r1s0 = [NSIndexPath indexPathForRow:1 inSection:0];
            NSIndexPath *r2s0 = [NSIndexPath indexPathForRow:2 inSection:0];
            
            tableView.visibleIndexPaths = @[r0s0, r1s0, r2s0];
            
            NSInteger lastRow = [tableView lastVisibleRowForSection:0];
            expect(lastRow).to.equal(2);
        });
        
        it(@"has sections before and after the specified section", ^{
            NSIndexPath *r0s0 = [NSIndexPath indexPathForRow:0 inSection:0];
            NSIndexPath *r1s0 = [NSIndexPath indexPathForRow:1 inSection:0];
            NSIndexPath *r2s0 = [NSIndexPath indexPathForRow:2 inSection:0];
            
            NSIndexPath *r0s1 = [NSIndexPath indexPathForRow:0 inSection:1];
            NSIndexPath *r1s1 = [NSIndexPath indexPathForRow:1 inSection:1];
            NSIndexPath *r2s1 = [NSIndexPath indexPathForRow:2 inSection:1];
            NSIndexPath *r3s1 = [NSIndexPath indexPathForRow:3 inSection:1];
            
            NSIndexPath *r0s2 = [NSIndexPath indexPathForRow:0 inSection:2];
            
            tableView.visibleIndexPaths = @[r0s0, r1s0, r2s0, r0s1, r1s1, r2s1, r3s1, r0s2];
            
            NSInteger lastRow = [tableView lastVisibleRowForSection:1];
            expect(lastRow).to.equal(3);
        });
    });
});

SpecEnd