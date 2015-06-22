#import "RTTestCommon.h"

#import "RTUserProfileViewController.h"
#import "RTArrayDataSource.h"

#import "RTUserProfilePresenter.h"
#import "RTUserSummaryPresenter.h"
#import "RTBrowseReelsPresenter.h"
#import "RTBrowseVideosPresenter.h"
#import "RTBrowseReelVideosPresenterFactory.h"
#import "RTVideoWireframe.h"
#import "RTThumbnailSupport.h"
#import "RTCurrentUserService.h"

#import "RTUserDescription.h"
#import "RTReelDescription.h"
#import "RTUserReelCell.h"

@interface RTUserProfileViewController (Test)

@property RTArrayDataSource *reelsDataSource;

@end

SpecBegin(RTUserProfileViewController)

describe(@"user profile view controller", ^{
    
    __block RTUserProfileViewController *viewController;
    
    __block RTUserProfilePresenter *userProfilePresenter;
    __block RTUserSummaryPresenter *userSummaryPresenter;
    __block RTBrowseReelsPresenter *reelsPresenter;
    
    __block id<RTBrowseReelVideosPresenterFactory> reelVideosPresenterFactory;
    __block id<RTVideoWireframe> reelVideosWireframe;
    
    __block RTThumbnailSupport *thumbnailSupport;
    __block RTCurrentUserService *currentUserService;

    __block UILabel *usernameLabel;
    __block UILabel *displayNameLabel;
    
    __block UILabel *subscribersLabel;
    __block UILabel *subscribedToLabel;
    
    __block UILabel *reelsCreatedLabel;
    __block UILabel *reelsFollowingLabel;
 
    __block UIButton *settingsButton;
    __block UITableView *tableView;
    
    beforeEach(^{
        userProfilePresenter = mock([RTUserProfilePresenter class]);
        userSummaryPresenter = mock([RTUserSummaryPresenter class]);
        reelsPresenter = mock([RTBrowseReelsPresenter class]);
        
        reelVideosPresenterFactory = mockProtocol(@protocol(RTBrowseReelVideosPresenterFactory));
        reelVideosWireframe = mockProtocol(@protocol(RTVideoWireframe));
        
        thumbnailSupport = mock([RTThumbnailSupport class]);
        currentUserService = mock([RTCurrentUserService class]);
 
        viewController = [RTUserProfileViewController viewControllerForUsername:username
                                                       withUserProfilePresenter:userProfilePresenter
                                                           userSummaryPresenter:userSummaryPresenter
                                                                 reelsPresenter:reelsPresenter
                                                     reelVideosPresenterFactory:reelVideosPresenterFactory
                                                            reelVideosWireframe:reelVideosWireframe
                                                               thumbnailSupport:thumbnailSupport
                                                             currentUserService:currentUserService];
        
        usernameLabel = [[UILabel alloc] init];
        displayNameLabel = [[UILabel alloc] init];
        
        subscribersLabel = [[UILabel alloc] init];
        subscribedToLabel = [[UILabel alloc] init];
        
        reelsCreatedLabel = [[UILabel alloc] init];
        reelsFollowingLabel = [[UILabel alloc] init];

        settingsButton = [[UIButton alloc] init];
        settingsButton.hidden = YES;

        tableView = mock([UITableView class]);
        
        viewController.usernameLabel = usernameLabel;
        viewController.displayNameLabel = displayNameLabel;
        
        viewController.subscribersLabel = subscribersLabel;
        viewController.subscribedToLabel = subscribedToLabel;
        
        viewController.reelsCreatedLabel = reelsCreatedLabel;
        viewController.reelsFollowingLabel = reelsFollowingLabel;
        
        viewController.settingsButton = settingsButton;
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
            [verify(userSummaryPresenter) requestedSummaryForUsername:username];
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
    
    describe(@"pressing settings button", ^{
        it(@"should request settings", ^{
            [viewController pressedSettingsButton];
            [verify(userProfilePresenter) requestedAccountSettings];
        });
    });
    
    context(@"user description required", ^{
        __block RTUserDescription *description;
        
        beforeEach(^{
            description = [RTUserDescription userDescriptionWithForUsername:@"foo"
                                                            withDisplayName:@"bar"
                                                          numberOfFollowers:@(1)
                                                          numberOfFollowees:@(2)
                                                         numberOfReelsOwned:@(3)
                                                numberOfAudienceMemberships:@(4)];
        });
        
        describe(@"show user summary", ^{
            beforeEach(^{
                [viewController showUserDescription:description];
            });
            
            it(@"should update labels with user info", ^{
                expect(viewController.usernameLabel.text).equal(@"Username: foo");
                expect(viewController.displayNameLabel.text).equal(@"Display name: bar");
                
                expect(viewController.subscribersLabel.text).equal(@"Subscribers: 1");
                expect(viewController.subscribedToLabel.text).equal(@"Subscribed to: 2");
                
                expect(viewController.reelsCreatedLabel.text).equal(@"Reels Created: 3");
                expect(viewController.reelsFollowingLabel.text).equal(@"Reels Following: 4");
            });
        });

        context(@"profile is for currently logged in user", ^{
            beforeEach(^{
                [given([currentUserService currentUsername]) willReturn:@"foo"];
                [viewController showUserDescription:description];
            });
            
            it(@"should display settings button", ^{
                expect(viewController.settingsButton.hidden).to.beFalsy();
            });
        });
        
        context(@"profile is not for currently logged in user", ^{
            beforeEach(^{
                [given([currentUserService currentUsername]) willReturn:@"notFoo"];
                [viewController showUserDescription:description];
            });
        
            it(@"should display settings button", ^{
                expect(viewController.settingsButton.hidden).to.beTruthy();
            });
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
                                                                                 view:cell
                                                                            wireframe:reelVideosWireframe])
                 willReturn:videosPresenter];

                [verifyCount(reelVideosPresenterFactory, never()) browseReelVideosPresenterForReelId:anything()
                                                                                            username:anything()
                                                                                                view:anything()
                                                                                           wireframe:anything()];
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