#import "RTTestCommon.h"

#import "RTBrowseAudienceMembersViewController.h"
#import "RTBrowseUsersPresenter.h"

#import "RTArrayDataSource.h"
#import "RTUserDescription.h"

@interface RTBrowseAudienceMembersViewController (Test)

@property RTArrayDataSource *audienceMembersDataSource;

@end

SpecBegin(RTBrowseAudienceMembersViewController)

describe(@"browse audience members view controller", ^{
    
    __block RTBrowseAudienceMembersViewController *viewController;

    __block RTBrowseUsersPresenter *presenter;
    __block UITableView *tableView;
    
    __block RTUserDescription *userDescription;

    beforeEach(^{
        presenter = mock([RTBrowseUsersPresenter class]);
        viewController = [RTBrowseAudienceMembersViewController viewControllerWithUsersPresenter:presenter];
        
        tableView = mock([UITableView class]);
        viewController.browseAudienceMembersTableView = tableView;
        
        userDescription = [RTUserDescription userDescriptionWithForUsername:username
                                                            withDisplayName:displayName
                                                          numberOfFollowers:@(1)
                                                          numberOfFollowees:@(2)
                                                         numberOfReelsOwned:@(3)
                                                numberOfAudienceMemberships:@(4)];
    });
    
    describe(@"required properties", ^{
        it(@"should use browse audience table view", ^{
            expect(viewController.tableView).to.equal(tableView);
        });
        
        it(@"should use users presenter", ^{
            expect(viewController.presenter).to.equal(presenter);
        });
    });

    describe(@"when view did load", ^{
        it(@"should use audience members data source for the table", ^{
            [viewController viewDidLoad];
            [verify(tableView) setDataSource:viewController.audienceMembersDataSource];
        });
    });
    
    describe(@"when view will appear", ^{
        it(@"should request the first page of audience members", ^{
            [viewController viewWillAppear:anything()];
            [verify(presenter) requestedNextPage];
        });
    });
    
    describe(@"row selected", ^{
        __block NSIndexPath *indexPath;
        
        beforeEach(^{
            indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            viewController.audienceMembersDataSource.items = @[userDescription];
            
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
            expect(viewController.audienceMembersDataSource.items).to.haveCountOf(1);
            expect(viewController.audienceMembersDataSource.items).to.contain(userDescription);
        });
        
        it(@"should reload the table data", ^{
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
            expect(viewController.audienceMembersDataSource.items).to.haveCountOf(0);
        });
        
        it(@"should reload table data", ^{
            [verify(tableView) reloadData];
        });
    });
});

SpecEnd