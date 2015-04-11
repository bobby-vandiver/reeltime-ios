#import "RTTestCommon.h"

#import "RTUserProfileViewController.h"
#import "RTArrayDataSource.h"

#import "RTUserSummaryPresenter.h"
#import "RTBrowseReelsPresenter.h"

@interface RTUserProfileViewController (Test)

@property RTArrayDataSource *reelsDataSource;

@end

SpecBegin(RTUserProfileViewController)

describe(@"user profile view controller", ^{
    
    __block RTUserProfileViewController *viewController;
    
    __block RTUserSummaryPresenter *userPresenter;
    __block RTBrowseReelsPresenter *reelsPresenter;
    
    __block UITableView *tableView;
    
    beforeEach(^{
        tableView = mock([UITableView class]);
        
        userPresenter = mock([RTUserSummaryPresenter class]);
        reelsPresenter = mock([RTBrowseReelsPresenter class]);

        viewController = [RTUserProfileViewController viewControllerForUsername:username
                                                              withUserPresenter:userPresenter
                                                                 reelsPresenter:reelsPresenter];
        viewController.reelsListTableView = tableView;
    });
    
    describe(@"when view did load", ^{
        it(@"should use reels data source for the table", ^{
            [viewController viewDidLoad];
            [verify(tableView) setDataSource:viewController.reelsDataSource];
        });
    });
    
    describe(@"when view will appear", ^{
        beforeEach(^{
            [viewController viewWillAppear:anything()];
        });

        it(@"should request the user's summary", ^{
            [verify(userPresenter) requestedSummaryForUsername:username];
        });
        
        it(@"should request the first page of reels", ^{
            [verify(reelsPresenter) requestedNextPage];
        });
    });
});

SpecEnd