#import "RTTestCommon.h"

#import "RTPagedListViewController.h"
#import "RTPagedListPresenter.h"

#import "RTArrayDataSource.h"
#import "UITableView+LastVisible.h"

#import "RTException.h"

@interface RTPagedListViewController (Test)

- (void)handleRefresh;

@end

@interface RTPagedListTestViewController : RTPagedListViewController

@property UITableView *mockTableView;
@property UIRefreshControl *mockRefreshControl;
@property RTPagedListPresenter *mockPresenter;

@end

@implementation RTPagedListTestViewController

- (UITableView *)tableView {
    return self.mockTableView;
}

- (UIRefreshControl *)refreshControl {
    return self.mockRefreshControl;
}

- (RTPagedListPresenter *)presenter {
    return self.mockPresenter;
}

- (UIRefreshControl *)createRefreshControl {
    return [[UIRefreshControl alloc] init];
}

@end

SpecBegin(RTPagedListViewController)

describe(@"paged list view controller", ^{

    __block RTPagedListTestViewController *viewController;
    __block RTPagedListViewController *abstractController;
    
    __block RTPagedListPresenter *presenter;

    __block UITableView *tableView;
    __block UIRefreshControl *refreshControl;
    
    __block MKTArgumentCaptor *captor;
    
    beforeEach(^{
        tableView = mock([UITableView class]);
        refreshControl = mock([UIRefreshControl class]);

        presenter = mock([RTPagedListPresenter class]);
        viewController = [[RTPagedListTestViewController alloc] init];

        viewController.mockTableView = tableView;
        viewController.mockPresenter = presenter;
        viewController.mockRefreshControl = refreshControl;

        abstractController = [[RTPagedListViewController alloc] init];
        captor = [[MKTArgumentCaptor alloc] init];
    });
    
    describe(@"abstract properties", ^{
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
    
    describe(@"refresh control", ^{
        it(@"should allow refresh control to be optional", ^{
            expect(abstractController.refreshControl).to.beNil();
        });
        
        it(@"should allow refresh control factory method to be undefined", ^{
            UIRefreshControl *control = [abstractController createRefreshControl];
            expect(control).to.beNil();
        });
        
        it(@"should ignore refresh control when loading view", ^{
            expect(^{
                [abstractController viewDidLoad];
            }).toNot.raiseAny();
        });
        
        it(@"should allow subclasses to provide custom refresh control", ^{
            [viewController viewDidLoad];
            [verify(tableView) addSubview:[captor capture]];
            expect([captor value]).to.beKindOf([UIRefreshControl class]);
        });
        
        it(@"should request refresh from presenter when refresh control is used", ^{
            [viewController handleRefresh];
            [verify(presenter) requestedRefreshWithCallback:[captor capture]];

            [verifyCount(refreshControl, never()) endRefreshing];
            
            RefreshCompletedCallback callback = [captor value];
            callback();

            [verify(refreshControl) endRefreshing];
        });
    });
});

SpecEnd
