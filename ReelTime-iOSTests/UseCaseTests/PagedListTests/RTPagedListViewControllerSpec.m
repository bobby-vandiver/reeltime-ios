#import "RTTestCommon.h"

#import "RTPagedListViewController.h"
#import "RTPagedListPresenter.h"

#import "RTArrayDataSource.h"
#import "UITableView+LastVisibleRow.h"

#import "RTException.h"

@interface RTPagedListTestViewController : RTPagedListViewController

@property UITableView *mockTableView;
@property RTPagedListPresenter *mockPresenter;

@end

@implementation RTPagedListTestViewController

- (UITableView *)tableView {
    return self.mockTableView;
}

- (RTPagedListPresenter *)presenter {
    return self.mockPresenter;
}

@end

SpecBegin(RTPagedListViewController)

describe(@"paged list view controller", ^{

    __block RTPagedListTestViewController *viewController;
    
    __block RTPagedListPresenter *presenter;
    __block UITableView *tableView;
    
    beforeEach(^{
        tableView = mock([UITableView class]);
        presenter = mock([RTPagedListPresenter class]);
        
        viewController = [[RTPagedListTestViewController alloc] init];

        viewController.mockTableView = tableView;
        viewController.mockPresenter = presenter;
    });
    
    describe(@"abstract properties", ^{
        __block RTPagedListViewController *abstractController;
        
        beforeEach(^{
            abstractController = [[RTPagedListViewController alloc] init];
        });
        
        it(@"should not allow presenter to be undefined", ^{
            expect(^{
                (void)abstractController.presenter;
            }).to.raiseWithReason(RTAbstractMethodException, @"Presenter must be provided by subclass");
        });
        
        it(@"should not allow table view to be undefined", ^{
            expect(^{
                (void)abstractController.tableView;
            }).to.raiseWithReason(RTAbstractMethodException, @"Table view must be provided by subclass");
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
            
            [viewController scrollViewDidScroll:anything()];
            [verify(presenter) requestedNextPage];
        });
        
        it(@"should not request next page when last visible row is not the last item in the list", ^{
            [given([tableView lastVisibleRowForSection:0]) willReturnInteger:0];
            [given([dataSource items]) willReturn:@[obj1, obj2]];
            
            [viewController scrollViewDidScroll:anything()];
            [verifyCount(presenter, never()) requestedNextPage];
        });
        
        it(@"should request next page when last visible row is the last item in the list", ^{
            [given([tableView lastVisibleRowForSection:0]) willReturnInteger:1];
            [given([dataSource items]) willReturn:@[obj1, obj2]];
            
            [viewController scrollViewDidScroll:anything()];
            [verify(presenter) requestedNextPage];
        });
    });
});

SpecEnd
