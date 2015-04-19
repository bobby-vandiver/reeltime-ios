#import "RTTestCommon.h"

#import "RTUserProfileViewController.h"
#import "RTArrayDataSource.h"

#import "RTUserSummaryPresenter.h"
#import "RTBrowseReelsPresenter.h"
#import "RTBrowseVideosPresenter.h"
#import "RTBrowseReelVideosPresenterFactory.h"
#import "RTThumbnailSupport.h"

#import "RTReelDescription.h"
#import "RTUserReelCell.h"

@interface RTUserProfileViewController (Test)

@property RTArrayDataSource *reelsDataSource;

@end

SpecBegin(RTUserProfileViewController)

describe(@"user profile view controller", ^{
    
    __block RTUserProfileViewController *viewController;
    
    __block RTUserSummaryPresenter *userPresenter;
    __block RTBrowseReelsPresenter *reelsPresenter;
    
    __block id<RTBrowseReelVideosPresenterFactory> reelVideosPresenterFactory;
    __block RTThumbnailSupport *thumbnailSupport;
    
    __block UITableView *tableView;
    
    beforeEach(^{
        tableView = mock([UITableView class]);
        
        userPresenter = mock([RTUserSummaryPresenter class]);
        reelsPresenter = mock([RTBrowseReelsPresenter class]);
        
        reelVideosPresenterFactory = mockProtocol(@protocol(RTBrowseReelVideosPresenterFactory));
        thumbnailSupport = mock([RTThumbnailSupport class]);

        viewController = [RTUserProfileViewController viewControllerForUsername:username
                                                              withUserPresenter:userPresenter
                                                                 reelsPresenter:reelsPresenter
                                                     reelVideosPresenterFactory:reelVideosPresenterFactory
                                                               thumbnailSupport:thumbnailSupport];

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
    
    describe(@"table properties", ^{

        it(@"row height is determined by thumbnail height", ^{
            CGSize stub = CGSizeMake(200, 400);
            [given([thumbnailSupport dimensions]) willReturnStruct:&stub objCType:@encode(CGSize)];
            
            CGFloat height = [viewController tableView:tableView heightForRowAtIndexPath:0];
            expect(height).to.equal(400);
        });
    });

    context(@"reel description required", ^{
        __block RTReelDescription *description;
        
        beforeEach(^{
            description = mock([RTReelDescription class]);
            expect(viewController.reelsDataSource.items).to.haveCountOf(0);
        });
        
        context(@"table data should be reloaded", ^{
            afterEach(^{
                [verify(tableView) reloadData];
            });

            describe(@"show reel description", ^{
                beforeEach(^{
                    [viewController showReelDescription:description];
                });
                
                it(@"should add description to data source", ^{
                    expect(viewController.reelsDataSource.items).to.haveCountOf(1);
                    expect(viewController.reelsDataSource.items).to.contain(description);
                });
            });
            
            describe(@"clear reel descriptions", ^{
                beforeEach(^{
                    [viewController showReelDescription:description];
                    expect(viewController.reelsDataSource.items).to.haveCountOf(1);
                    
                    [verify(tableView) reset];
                });
                
                it(@"should remove all items", ^{
                     [viewController clearReelDescriptions];
                     expect(viewController.reelsDataSource.items).to.haveCountOf(0);
                });
            });
        });
        
        describe(@"cell configuration", ^{
            __block RTUserReelCell *cell;
            __block RTBrowseVideosPresenter *videosPresenter;
            
            beforeEach(^{
                cell = mock([RTUserReelCell class]);
                videosPresenter = mock([RTBrowseVideosPresenter class]);
                
                [given([description reelId]) willReturn:@(reelId)];
                [given([reelVideosPresenterFactory browseReelVideosPresenterForReelId:@(reelId)
                                                                             username:username
                                                                                 view:cell])
                 willReturn:videosPresenter];

                [verifyCount(reelVideosPresenterFactory, never()) browseReelVideosPresenterForReelId:anything()
                                                                                            username:anything()
                                                                                                view:anything()];
                [verifyCount(cell, never()) configureWithVideosPresenter:anything()];
            });
            
            it(@"should inject videos presenter configured for user and reel", ^{
                viewController.reelsDataSource.configureCellBlock(cell, description);
                [verify(cell) configureWithVideosPresenter:videosPresenter];
            });
        });
    });
});

SpecEnd