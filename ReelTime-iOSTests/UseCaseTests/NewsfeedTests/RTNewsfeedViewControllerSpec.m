#import "RTTestCommon.h"

#import "RTNewsfeedViewController.h"
#import "RTNewsfeedPresenter.h"

#import "RTArrayDataSource.h"

#import "RTActivityCell.h"
#import "RTActivityCell+ConfigureForRTActivityMessage.h"

#import "RTActivityMessage.h"

#import "RTStringWithEmbeddedLinks.h"
#import "RTEmbeddedURL.h"

SpecBegin(RTNewsfeedViewController)

describe(@"newsfeed view controller", ^{

    __block RTNewsfeedViewController *viewController;

    __block RTNewsfeedPresenter *presenter;
    __block UITableView *tableView;
    
    beforeEach(^{
        tableView = mock([UITableView class]);
        presenter = mock([RTNewsfeedPresenter class]);
        
        viewController = [RTNewsfeedViewController viewControllerWithPresenter:presenter];
        viewController.tableView = tableView;
    });
    
    describe(@"when created from storyboard", ^{
        it(@"should have an empty data source", ^{
            expect(viewController.dataSource).toNot.beNil();
            expect(viewController.dataSource.items).toNot.beNil();
            expect(viewController.dataSource.items.count).to.equal(0);
        });
    });
    
    describe(@"when view did load", ^{
        beforeEach(^{
            [viewController viewDidLoad];
        });
        
        it(@"should register custom activity cell class", ^{
            [verify(tableView) registerClass:[RTActivityCell class] forCellReuseIdentifier:@"ActivityCell"];
        });
        
        it(@"should provide set up table view data source", ^{
            [verify(tableView) setDataSource:viewController.dataSource];
        });
        
        it(@"should request the first page of activities", ^{
            [verify(presenter) requestedNextPage];
        });
    });
    
    context(@"activity message is required", ^{
        __block RTActivityMessage *message;
        
        beforeEach(^{
            RTStringWithEmbeddedLinks *stringWithLinks = [[RTStringWithEmbeddedLinks alloc] initWithString:@"this is a test"];
            [stringWithLinks addLinkToURL:[NSURL URLWithString:@"http://test.com"] forString:@"is"];
            
            message = [RTActivityMessage activityMessage:stringWithLinks withType:RTActivityTypeCreateReel];
        });
        
        describe(@"activity cell configuration", ^{
            it(@"should delegate to activity cell for configuration", ^{
                RTActivityCell *cell = mock([RTActivityCell class]);
               
                viewController.dataSource.configureCellBlock(cell, message);
                [verify(cell) configureForActivityMessage:message withLabelDelegate:presenter];
            });
        });
    
        describe(@"show message requested", ^{
            it(@"should add message to data source", ^{
                [viewController showMessage:message];

                expect(viewController.dataSource.items.count).to.equal(1);
                expect(viewController.dataSource.items).to.contain(message);
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
                expect(viewController.dataSource.items.count).to.equal(0);
            });
            
            it(@"should reload the table data", ^{
                [viewController clearMessages];
                [verify(tableView) reloadData];
            });
        });
    });
});

SpecEnd