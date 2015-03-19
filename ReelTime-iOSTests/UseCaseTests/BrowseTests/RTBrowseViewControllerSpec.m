#import "RTTestCommon.h"

#import "RTBrowseViewController.h"
#import "RTArrayDataSource.h"

#import "RTBrowseUsersPresenter.h"
#import "RTBrowseReelsPresenter.h"
#import "RTBrowseVideosPresenter.h"

#import "RTUserMessage.h"
#import "RTReelMessage.h"
#import "RTVideoMessage.h"

#import "UITableView+LastVisibleRow.h"

@interface RTBrowseViewController (Test)

@property CGPoint usersListScrollPosition;
@property CGPoint reelsListScrollPosition;
@property CGPoint videosListScrollPosition;

@property RTArrayDataSource *usersDataSource;
@property RTArrayDataSource *reelsDataSource;
@property RTArrayDataSource *videosDataSource;

@property RTBrowseUsersPresenter *usersPresenter;
@property RTBrowseReelsPresenter *reelsPresenter;
@property RTBrowseVideosPresenter *videosPresenter;

@property (weak, nonatomic) IBOutlet UITableView *browseListTableView;

- (void)makeUsersListActive;

- (void)makeReelsListActive;

- (void)makeVideosListActive;

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
        viewController.browseListTableView = tableView;
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
    
    describe(@"presenter should reflect current active list", ^{
        it(@"should return users presenter", ^{
            [viewController makeUsersListActive];
            expect(viewController.presenter).to.beIdenticalTo(viewController.usersPresenter);
        });
        
        it(@"should return reels presenter", ^{
            [viewController makeReelsListActive];
            expect(viewController.presenter).to.beIdenticalTo(viewController.reelsPresenter);
        });
        
        it(@"should return videos presenter", ^{
            [viewController makeVideosListActive];
            expect(viewController.presenter).to.beIdenticalTo(viewController.videosPresenter);
        });
    });

    describe(@"selecting a different list", ^{
        afterEach(^{
            [verify(tableView) reloadData];
        });
        
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
    
    describe(@"row selected", ^{
        __block NSIndexPath *indexPath;
        
        __block RTUserMessage *userMessage;
        __block RTReelMessage *reelMessage;
        __block RTVideoMessage *videoMessage;
        
        beforeEach(^{
            indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            
            userMessage = [RTUserMessage userMessageWithText:@"text" forUsername:username];
            reelMessage = [RTReelMessage reelMessageWithText:@"text" forReelId:@(reelId)];
            videoMessage = [RTVideoMessage videoMessageWithText:@"text" videoId:@(videoId)];
            
            viewController.usersDataSource.items = @[userMessage];
            viewController.reelsDataSource.items = @[reelMessage];
            viewController.videosDataSource.items = @[videoMessage];
        });
        
        afterEach(^{
            [verify(tableView) deselectRowAtIndexPath:indexPath animated:NO];
        });
        
        it(@"should present selected user", ^{
            [viewController makeUsersListActive];
            [viewController tableView:tableView didSelectRowAtIndexPath:indexPath];
            [verify(usersPresenter) requestedUserDetailsForUsername:username];
        });
        
        it(@"should present selected reel", ^{
            [viewController makeReelsListActive];
            [viewController tableView:tableView didSelectRowAtIndexPath:indexPath];
            [verify(reelsPresenter) requestedReelDetailsForReelId:@(reelId)];
        });
        
        it(@"should present selected video", ^{
            [viewController makeVideosListActive];
            [viewController tableView:tableView didSelectRowAtIndexPath:indexPath];
            [verify(videosPresenter) requestedVideoDetailsForVideoId:@(videoId)];
        });
    });
    
    describe(@"scrolling", ^{
        it(@"should start all lists at the top", ^{
            CGPoint bogus = CGPointMake(120, 320);
            CGPoint origin = CGPointZero;
            
            expect(origin).toNot.equal(bogus);
            
            viewController.usersListScrollPosition = bogus;
            viewController.reelsListScrollPosition = bogus;
            viewController.videosListScrollPosition = bogus;
            
            [given([tableView contentOffset]) willReturnStruct:&origin objCType:@encode(CGPoint)];
            [viewController viewDidLoad];
            
            expect(viewController.usersListScrollPosition).to.equal(origin);
            expect(viewController.reelsListScrollPosition).to.equal(origin);
            expect(viewController.videosListScrollPosition).to.equal(origin);
        });
        
        
        context(@"lists start at origin", ^{
            __block CGPoint origin;
            __block CGPoint scrollPosition;
            
            beforeEach(^{
                origin = CGPointZero;
                scrollPosition = CGPointMake(0, 200);
                
                viewController.usersListScrollPosition = CGPointZero;
                viewController.reelsListScrollPosition = CGPointZero;
                viewController.videosListScrollPosition = CGPointZero;

                [given([tableView contentOffset]) willReturnStruct:&origin objCType:@encode(CGPoint)];
            });

            void (^stubContentOffset)() = ^{
                [verify(tableView) reset];
                [given([tableView contentOffset]) willReturnStruct:&scrollPosition objCType:@encode(CGPoint)];
            };
            
            it(@"should remember users scroll position", ^{
                [viewController makeUsersListActive];

                stubContentOffset();
                [viewController makeReelsListActive];
                
                expect(viewController.usersListScrollPosition).to.equal(scrollPosition);
                expect(viewController.reelsListScrollPosition).to.equal(origin);
                expect(viewController.videosListScrollPosition).to.equal(origin);
            });
            
            it(@"should remember reels scroll position", ^{
                [viewController makeReelsListActive];
                
                stubContentOffset();
                [viewController makeUsersListActive];
                
                expect(viewController.reelsListScrollPosition).to.equal(scrollPosition);
                expect(viewController.usersListScrollPosition).to.equal(origin);
                expect(viewController.videosListScrollPosition).to.equal(origin);
            });
            
            it(@"should remember videos scroll position", ^{
                [viewController makeVideosListActive];
                
                stubContentOffset();
                [viewController makeUsersListActive];

                expect(viewController.videosListScrollPosition).to.equal(scrollPosition);
                expect(viewController.usersListScrollPosition).to.equal(origin);
                expect(viewController.reelsListScrollPosition).to.equal(origin);
            });
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
                [viewController makeReelsListActive];
                [verify(tableView) reset];
                
                [viewController showUserMessage:userMessage];
                [verifyCount(tableView, never()) reloadData];
            });
            
            it(@"should reload the table data when users data source is active", ^{
                [viewController makeUsersListActive];
                [verify(tableView) reset];

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
                [viewController makeReelsListActive];
                [viewController showUserMessage:userMessage];
                
                [verify(tableView) reset];
                
                [viewController clearUserMessages];
                [verifyCount(tableView, never()) reloadData];
            });
            
            it(@"should reload table data when users data source is active", ^{
                [viewController makeUsersListActive];
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
                [viewController makeUsersListActive];
                [verify(tableView) reset];

                [viewController showReelMessage:reelMessage];
                [verifyCount(tableView, never()) reloadData];
            });
            
            it(@"should reload the table data when reels data source is active", ^{
                [viewController makeReelsListActive];
                [verify(tableView) reset];

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
                [viewController makeUsersListActive];
                [viewController showReelMessage:reelMessage];
                
                [verify(tableView) reset];
                
                [viewController clearReelMessages];
                [verifyCount(tableView, never()) reloadData];
            });
            
            it(@"should reload table data when reels data source is active", ^{
                [viewController makeReelsListActive];
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
                [viewController makeUsersListActive];
                [verify(tableView) reset];

                [viewController showVideoMessage:videoMessage];
                [verifyCount(tableView, never()) reloadData];
            });
            
            it(@"should reload the table data when videos data source is active", ^{
                [viewController makeVideosListActive];
                [verify(tableView) reset];

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
                [viewController makeUsersListActive];
                [viewController showVideoMessage:videoMessage];
                
                [verify(tableView) reset];
                
                [viewController clearVideoMessages];
                [verifyCount(tableView, never()) reloadData];
            });
            
            it(@"should reload table data when videos data source is active", ^{
                [viewController makeVideosListActive];
                [viewController showVideoMessage:videoMessage];
                
                [verify(tableView) reset];
                
                [viewController clearVideoMessages];
                [verify(tableView) reloadData];
            });
        });
    });
});

SpecEnd
