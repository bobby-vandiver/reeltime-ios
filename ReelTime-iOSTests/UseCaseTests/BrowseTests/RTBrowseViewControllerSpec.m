#import "RTTestCommon.h"

#import "RTBrowseViewController.h"
#import "RTArrayDataSource.h"

#import "RTBrowseUsersPresenter.h"
#import "RTBrowseReelsPresenter.h"
#import "RTBrowseVideosPresenter.h"

#import "RTUserMessage.h"
#import "RTReelMessage.h"
#import "RTVideoMessage.h"

@interface RTBrowseViewController (Test)

@property RTArrayDataSource *usersDataSource;
@property RTArrayDataSource *reelsDataSource;
@property RTArrayDataSource *videosDataSource;

- (void)useUsersDataSource;

- (void)useReelsDataSource;

- (void)useVideosDataSource;

@end

SpecBegin(RTBrowseViewController)

describe(@"browse view controller", ^{
    
    __block RTBrowseViewController *viewController;
    
    __block RTBrowseUsersPresenter *usersPresenter;
    __block RTBrowseReelsPresenter *reelsPresenter;
    __block RTBrowseVideosPresenter *videosPresenter;
    
    __block UISegmentedControl *segmentedControl;
    __block UITableView *tableView;
    
    beforeEach(^{
        segmentedControl = mock([UISegmentedControl class]);
        tableView = mock([UITableView class]);

        usersPresenter = mock([RTBrowseUsersPresenter class]);
        reelsPresenter = mock([RTBrowseReelsPresenter class]);
        videosPresenter = mock([RTBrowseVideosPresenter class]);
        
        viewController = [RTBrowseViewController viewControllerWithUsersPresenter:usersPresenter
                                                                   reelsPresenter:reelsPresenter
                                                                  videosPresenter:videosPresenter];
        
        viewController.segmentedControl = segmentedControl;
        viewController.tableView = tableView;
    });
    
    describe(@"when view did load", ^{
        it(@"should use users data source", ^{
            [viewController viewDidLoad];
            [verify(tableView) setDataSource:viewController.usersDataSource];
        });
    });
    
    describe(@"when view will appear", ^{
        it(@"should load the first page for each data source", ^{
            [viewController viewWillAppear:anything()];

            [verify(usersPresenter) requestedNextPage];
            [verify(reelsPresenter) requestedNextPage];
            [verify(videosPresenter) requestedNextPage];
        });
    });
    
    describe(@"selecting a different list", ^{
        it(@"should select users data source", ^{
            [given([segmentedControl selectedSegmentIndex]) willReturnInteger:0];
            
            [viewController segmentedControlChanged];
            [verify(tableView) setDataSource:viewController.usersDataSource];
        });
        
        it(@"should select reels data source", ^{
            [given([segmentedControl selectedSegmentIndex]) willReturnInteger:1];
            
            [viewController segmentedControlChanged];
            [verify(tableView) setDataSource:viewController.reelsDataSource];
        });
        
        it(@"should select videos data source", ^{
            [given([segmentedControl selectedSegmentIndex]) willReturnInteger:2];
            
            [viewController segmentedControlChanged];
            [verify(tableView) setDataSource:viewController.videosDataSource];
        });
    });
    
    context(@"user message is required", ^{
        __block RTUserMessage *userMessage;
        
        beforeEach(^{
            userMessage = [RTUserMessage userMessageWithText:@"user" forUsername:username];
            expect(viewController.usersDataSource.items).to.haveCountOf(0);
        });
        
        describe(@"show message requested", ^{
            it(@"should add message to users data source", ^{
                [viewController showUserMessage:userMessage];
                
                expect(viewController.usersDataSource.items).to.haveCountOf(1);
                expect(viewController.usersDataSource.items).to.contain(userMessage);
            });
            
            it(@"should not reload the table data when users data source isn't active", ^{
                [viewController useReelsDataSource];
                [viewController showUserMessage:userMessage];
                [verifyCount(tableView, never()) reloadData];
            });
            
            it(@"should reload the table data when users data source is active", ^{
                [viewController useUsersDataSource];
                [viewController showUserMessage:userMessage];
                [verify(tableView) reloadData];
            });
        });
        
        describe(@"clear messages requested", ^{
            it(@"should reset users data source", ^{
                [viewController showUserMessage:userMessage];
                
                [viewController clearUserMessages];
                expect(viewController.usersDataSource.items).to.haveCountOf(0);
            });
            
            it(@"should not reload table data when users data source isn't active", ^{
                [viewController useReelsDataSource];
                [viewController showUserMessage:userMessage];
                
                [verify(tableView) reset];
                
                [viewController clearUserMessages];
                [verifyCount(tableView, never()) reloadData];
            });
            
            it(@"should reload table data when users data source is active", ^{
                [viewController useUsersDataSource];
                [viewController showUserMessage:userMessage];

                [verify(tableView) reset];
                
                [viewController clearUserMessages];
                [verify(tableView) reloadData];
            });
        });
    });
    
    context(@"reel message is required", ^{
        __block RTReelMessage *reelMessage;
        
        beforeEach(^{
            reelMessage = [RTReelMessage reelMessageWithText:@"reel" forReelId:@(reelId)];
            expect(viewController.reelsDataSource.items).to.haveCountOf(0);
        });
        
        describe(@"show message requested", ^{
            it(@"should add message to reels data source", ^{
                [viewController showReelMessage:reelMessage];
                
                expect(viewController.reelsDataSource.items).to.haveCountOf(1);
                expect(viewController.reelsDataSource.items).to.contain(reelMessage);
            });
            
            it(@"should not reload the table data when reels data source isn't active", ^{
                [viewController useUsersDataSource];
                [viewController showReelMessage:reelMessage];
                [verifyCount(tableView, never()) reloadData];
            });
            
            it(@"should reload the table data when reels data source is active", ^{
                [viewController useReelsDataSource];
                [viewController showReelMessage:reelMessage];
                [verify(tableView) reloadData];
            });
        });
        
        describe(@"clear messages requested", ^{
            it(@"should reset reels data source", ^{
                [viewController showReelMessage:reelMessage];
                
                [viewController clearReelMessages];
                expect(viewController.reelsDataSource.items).to.haveCountOf(0);
            });
            
            it(@"should not reload table data when reels data source isn't active", ^{
                [viewController useUsersDataSource];
                [viewController showReelMessage:reelMessage];
                
                [verify(tableView) reset];
                
                [viewController clearReelMessages];
                [verifyCount(tableView, never()) reloadData];
            });
            
            it(@"should reload table data when reels data source is active", ^{
                [viewController useReelsDataSource];
                [viewController showReelMessage:reelMessage];
                
                [verify(tableView) reset];
                
                [viewController clearReelMessages];
                [verify(tableView) reloadData];
            });
        });
    });
    
    context(@"video message is required", ^{
        __block RTVideoMessage *videoMessage;
        
        beforeEach(^{
            videoMessage = [RTVideoMessage videoMessageWithText:@"video" videoId:@(videoId)];
            expect(viewController.videosDataSource.items).to.haveCountOf(0);
        });
        
        describe(@"show message requested", ^{
            it(@"should add message to videos data source", ^{
                [viewController showVideoMessage:videoMessage];
                
                expect(viewController.videosDataSource.items).to.haveCountOf(1);
                expect(viewController.videosDataSource.items).to.contain(videoMessage);
            });
            
            it(@"should not reload the table data when videos data source isn't active", ^{
                [viewController useUsersDataSource];
                [viewController showVideoMessage:videoMessage];
                [verifyCount(tableView, never()) reloadData];
            });
            
            it(@"should reload the table data when videos data source is active", ^{
                [viewController useVideosDataSource];
                [viewController showVideoMessage:videoMessage];
                [verify(tableView) reloadData];
            });
        });
        
        describe(@"clear messages requested", ^{
            it(@"should reset videos data source", ^{
                [viewController showVideoMessage:videoMessage];
                
                [viewController clearVideoMessages];
                expect(viewController.videosDataSource.items).to.haveCountOf(0);
            });
            
            it(@"should not reload table data when videos data source isn't active", ^{
                [viewController useUsersDataSource];
                [viewController showVideoMessage:videoMessage];
                
                [verify(tableView) reset];
                
                [viewController clearVideoMessages];
                [verifyCount(tableView, never()) reloadData];
            });
            
            it(@"should reload table data when videos data source is active", ^{
                [viewController useVideosDataSource];
                [viewController showVideoMessage:videoMessage];
                
                [verify(tableView) reset];
                
                [viewController clearVideoMessages];
                [verify(tableView) reloadData];
            });
        });
    });
});

SpecEnd
