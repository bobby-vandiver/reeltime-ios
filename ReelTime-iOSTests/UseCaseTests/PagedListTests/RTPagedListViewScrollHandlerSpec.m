#import "RTTestCommon.h"

#import "RTPagedListViewScrollHandler.h"
#import "RTPagedListPresenter.h"

#import "RTArrayDataSource.h"

#import <UIKit/UIKit.h>
#import "UITableView+LastVisible.h"

SpecBegin(RTPagedListViewScrollHandler)

describe(@"paged list view scroll handler", ^{
    
    __block RTPagedListViewScrollHandler *scrollHandler;
    __block RTPagedListPresenter *presenter;
    
    __block UITableView *tableView;
    __block UICollectionView *collectionView;
    
    beforeEach(^{
        scrollHandler = [[RTPagedListViewScrollHandler alloc] init];
        presenter = mock([RTPagedListPresenter class]);
        
        tableView = mock([UITableView class]);
        collectionView = mock([UICollectionView class]);
    });
    
    describe(@"invalid data source type", ^{
        it(@"invalid table view data source", ^{
            id<UITableViewDataSource> dataSource = mockProtocol(@protocol(UITableViewDataSource));
            [given([tableView dataSource]) willReturn:dataSource];
            
            expect(^{
                [scrollHandler handleScrollForTableView:tableView withPresenter:presenter];
            }).to.raiseWithReason(@"NSInvalidArgumentException", @"Data source must be RTArrayDataSource");
        });
    });
   
    describe(@"loading the next page for the active list when scrolling to the bottom", ^{
        __block RTArrayDataSource *dataSource;
        
        __block NSObject *obj1;
        __block NSObject *obj2;
        
        beforeEach(^{
            dataSource = mock([RTArrayDataSource class]);
            [given([tableView dataSource]) willReturn:dataSource];
            
            obj1 = [NSObject new];
            obj2 = [NSObject new];
        });
        
        it(@"should request next page for empty data source", ^{
            [given([tableView lastVisibleRowForSection:0]) willReturnInteger:NSNotFound];
            [given([dataSource items]) willReturn:@[]];
            
            [scrollHandler handleScrollForTableView:tableView withPresenter:presenter];
            [verify(presenter) requestedNextPage];
        });
        
        it(@"should not request next page when last visible row is not the last item in the list", ^{
            [given([tableView lastVisibleRowForSection:0]) willReturnInteger:0];
            [given([dataSource items]) willReturn:@[obj1, obj2]];
            
            [scrollHandler handleScrollForTableView:tableView withPresenter:presenter];
            [verifyCount(presenter, never()) requestedNextPage];
        });
        
        it(@"should request next page when last visible row is the last item in the list", ^{
            [given([tableView lastVisibleRowForSection:0]) willReturnInteger:1];
            [given([dataSource items]) willReturn:@[obj1, obj2]];
            
            [scrollHandler handleScrollForTableView:tableView withPresenter:presenter];
            [verify(presenter) requestedNextPage];
        });
    });

});

SpecEnd