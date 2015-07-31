#import "RTTestCommon.h"

#import "RTNewsfeedViewController.h"
#import "RTNewsfeedPresenter.h"

#import "RTArrayDataSource.h"

#import "RTActivityCell.h"
#import "RTActivityMessage.h"

@interface RTNewsfeedViewController (Test)

@property RTArrayDataSource *activitiesDataSource;

@end

SpecBegin(RTNewsfeedViewController)

describe(@"newsfeed view controller", ^{

    __block RTNewsfeedViewController *viewController;

    __block RTNewsfeedPresenter *presenter;
    __block UITableView *tableView;
    
    beforeEach(^{
        tableView = mock([UITableView class]);
        presenter = mock([RTNewsfeedPresenter class]);
        
        viewController = [RTNewsfeedViewController viewControllerWithPresenter:presenter];
        viewController.activitiesTableView = tableView;
    });
    
    describe(@"when created from storyboard", ^{
        it(@"should have an empty data source", ^{
            expect(viewController.activitiesDataSource).toNot.beNil();
            expect(viewController.activitiesDataSource.items).toNot.beNil();
            expect(viewController.activitiesDataSource.items.count).to.equal(0);
        });
    });
    
    describe(@"when view did load", ^{
        beforeEach(^{
            [viewController viewDidLoad];
        });
        
        it(@"should set up table view data source", ^{
            [verify(tableView) setDataSource:viewController.activitiesDataSource];
        });
    });
    
    describe(@"when view will appear", ^{
        beforeEach(^{
            [viewController viewWillAppear:anything()];
        });
        
        it(@"should request the first page of activities", ^{
            [verify(presenter) requestedNextPage];
        });
    });
    
    context(@"activity message is required", ^{
        __block RTActivityMessage *message;
        
        beforeEach(^{
            message = [RTActivityMessage activityMessageWithText:@"this is a test"
                                                            type:RTActivityTypeAddVideoToReel
                                                     forUsername:username
                                                          reelId:@(reelId)
                                                         videoId:@(videoId)];
        });
    
        describe(@"show message requested", ^{
            it(@"should add message to data source", ^{
                [viewController showMessage:message];

                expect(viewController.activitiesDataSource.items.count).to.equal(1);
                expect(viewController.activitiesDataSource.items).to.contain(message);
            });
            
            it(@"should reload the table data", ^{
                [viewController showMessage:message];
                [verify(tableView) reloadData];
            });
        });
        
        describe(@"clear messages requested", ^{
            it(@"should reset the data source", ^{
                [viewController showMessage:message];

                [viewController clearMessages];
                expect(viewController.activitiesDataSource.items.count).to.equal(0);
            });
            
            it(@"should reload the table data", ^{
                [viewController clearMessages];
                [verify(tableView) reloadData];
            });
        });
    });
});

SpecEnd