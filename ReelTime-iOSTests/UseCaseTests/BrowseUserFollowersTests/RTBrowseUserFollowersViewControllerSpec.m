#import "RTTestCommon.h"

#import "RTBrowseUserFollowersViewController.h"
#import "RTBrowseUsersPresenter.h"

#import "RTArrayDataSource.h"
#import "RTUserDescription.h"

@interface RTBrowseUserFollowersViewController (Test)

@property RTArrayDataSource *userFollowersDataSource;

@end

SpecBegin(RTBrowseUserFollowersViewController)

describe(@"browse user followers view controller", ^{
    
    __block RTBrowseUserFollowersViewController *viewController;
    
    __block RTBrowseUsersPresenter *presenter;
    __block UITableView *tableView;
    
    __block RTUserDescription *userDescription;
    
    beforeEach(^{
        presenter = mock([RTBrowseUsersPresenter class]);
        viewController = [RTBrowseUserFollowersViewController viewControllerWithUsersPresenter:presenter];
        
        tableView = mock([UITableView class]);
        viewController.browseUserFollowersTableView = tableView;
        
        userDescription = [RTUserDescription userDescriptionWithForUsername:username
                                                            withDisplayName:displayName
                                                          numberOfFollowers:@(1)
                                                          numberOfFollowees:@(2)
                                                         numberOfReelsOwned:@(3)
                                                numberOfAudienceMemberships:@(4)
                                                     currentUserIsFollowing:@(NO)];
    });
    
    describe(@"required properties", ^{
        it(@"should use browse followers table view", ^{
            expect(viewController.tableView).to.equal(tableView);
        });
        
        it(@"should use users presenter", ^{
            expect(viewController.presenter).to.equal(presenter);
        });
    });
    
    describe(@"when view did load", ^{
        it(@"should use followers data source", ^{
            [viewController viewDidLoad];
            [verify(tableView) setDataSource:viewController.userFollowersDataSource];
        });
    });
    
    describe(@"when view will appear", ^{
        it(@"should request the first page of followers", ^{
            [viewController viewWillAppear:anything()];
            [verify(presenter) requestedNextPage];
        });
    });
    
    describe(@"row selected", ^{
        __block NSIndexPath *indexPath;
        
        beforeEach(^{
            indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            viewController.userFollowersDataSource.items = @[userDescription];
            
            [viewController tableView:tableView didSelectRowAtIndexPath:indexPath];
        });
        
        afterEach(^{
            [verify(tableView) deselectRowAtIndexPath:indexPath animated:NO];
        });
        
        it(@"should present selected user", ^{
            [verify(presenter) requestedUserDetailsForUsername:username];
        });
    });
    
    describe(@"show description requested", ^{
        beforeEach(^{
            [viewController showUserDescription:userDescription];
        });
        
        it(@"should add description to data source", ^{
            expect(viewController.userFollowersDataSource.items).to.haveACountOf(1);
            expect(viewController.userFollowersDataSource.items).to.contain(userDescription);
        });
        
        it(@"should reload table data", ^{
            [verify(tableView) reloadData];
        });
    });
    
    describe(@"clear descriptions requested", ^{
        beforeEach(^{
            [viewController showUserDescription:userDescription];
            [verify(tableView) reset];
            [viewController clearUserDescriptions];
        });
        
        it(@"should reset data source", ^{
            expect(viewController.userFollowersDataSource.items).to.haveACountOf(0);
        });
        
        it(@"should reload table data", ^{
            [verify(tableView) reloadData];
        });
    });
});

SpecEnd
