#import "RTTestCommon.h"

#import "UICollectionView+LastVisible.h"

@interface TestUICollectionView : UICollectionView

@property NSArray *visibleIndexPaths;

@end

@implementation TestUICollectionView

- (NSArray *)indexPathsForVisibleItems {
    return self.visibleIndexPaths;
}

@end

SpecBegin(UICollectionView_LastVisible)

describe(@"collection view last visible category", ^{
    
    __block TestUICollectionView *collectionView;
    
    beforeEach(^{
        CGRect frame = CGRectMake(0, 0, 100, 100);
        UICollectionViewLayout *layout = mock([UICollectionViewLayout class]);
        
        collectionView = [[TestUICollectionView alloc] initWithFrame:frame
                                                collectionViewLayout:layout];
    });
    
    describe(@"last visible section", ^{
        it(@"has no visible paths", ^{
            collectionView.visibleIndexPaths = nil;
            
            NSInteger lastSection = [collectionView lastVisibleSection];
            expect(lastSection).to.equal(NSNotFound);
        });
        
        it(@"has one visible path", ^{
            NSIndexPath *r0s0 = [NSIndexPath indexPathForRow:0 inSection:0];
            collectionView.visibleIndexPaths = @[r0s0];
            
            NSInteger lastSection = [collectionView lastVisibleSection];
            expect(lastSection).to.equal(0);
        });
        
        it(@"has multiple visible paths", ^{
            NSIndexPath *r0s0 = [NSIndexPath indexPathForRow:0 inSection:0];
            NSIndexPath *r0s1 = [NSIndexPath indexPathForRow:0 inSection:1];
            NSIndexPath *r0s2 = [NSIndexPath indexPathForRow:0 inSection:2];
            NSIndexPath *r0s3 = [NSIndexPath indexPathForRow:0 inSection:3];
            
            collectionView.visibleIndexPaths = @[r0s0, r0s1, r0s2, r0s3];
            
            NSInteger lastSection = [collectionView lastVisibleSection];
            expect(lastSection).to.equal(3);
        });
    });
    
    describe(@"last visible row for section", ^{
        it(@"requested section is not found", ^{
            NSInteger lastRow = [collectionView lastVisibleRowForSection:NSNotFound];
            expect(lastRow).to.equal(NSNotFound);
        });
        
        it(@"has no visible paths", ^{
            collectionView.visibleIndexPaths = nil;
            
            NSInteger lastRow = [collectionView lastVisibleRowForSection:0];
            expect(lastRow).to.equal(NSNotFound);
        });
        
        it(@"has paths but not for the requested section", ^{
            NSIndexPath *r1s0 = [NSIndexPath indexPathForRow:1 inSection:0];
            collectionView.visibleIndexPaths = @[r1s0];
            
            NSInteger lastRow = [collectionView lastVisibleRowForSection:1];
            expect(lastRow).to.equal(NSNotFound);
        });
        
        it(@"has multiple rows in requested section", ^{
            NSIndexPath *r0s0 = [NSIndexPath indexPathForRow:0 inSection:0];
            NSIndexPath *r1s0 = [NSIndexPath indexPathForRow:1 inSection:0];
            NSIndexPath *r2s0 = [NSIndexPath indexPathForRow:2 inSection:0];
            
            collectionView.visibleIndexPaths = @[r0s0, r1s0, r2s0];
            
            NSInteger lastRow = [collectionView lastVisibleRowForSection:0];
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
            
            collectionView.visibleIndexPaths = @[r0s0, r1s0, r2s0, r0s1, r1s1, r2s1, r3s1, r0s2];
            
            NSInteger lastRow = [collectionView lastVisibleRowForSection:1];
            expect(lastRow).to.equal(3);
        });
    });
});

SpecEnd