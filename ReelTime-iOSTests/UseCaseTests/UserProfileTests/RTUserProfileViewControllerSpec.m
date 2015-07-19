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

#import "RTUserReelHeaderView.h"
#import "RTUserReelFooterView.h"

#import "RTUserDescription.h"
#import "RTReelDescription.h"
#import "RTUserReelCell.h"

@interface RTUserProfileViewController (Test)

@property RTArrayDataSource *reelsDataSource;

@end

@interface RTReelDescription (Test)

@property (readwrite) NSNumber *audienceSize;
@property (readwrite) NSNumber *numberOfVideos;
@property (readwrite) NSNumber *currentUserIsAnAudienceMember;

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
    
    describe(@"required properties", ^{
        it(@"should use reels list table view", ^{
            expect(viewController.tableView).to.equal(tableView);
        });
        
        it(@"should use reels presenter", ^{
            expect(viewController.presenter).to.equal(reelsPresenter);
        });
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
    
    describe(@"pressing follow reel button", ^{
        it(@"should request reel is followed", ^{
            // TODO!
        });
    });
    
    describe(@"pressing list audience button", ^{
        it(@"should present audience members for specified reel", ^{
            [viewController footerView:anything() didPressListAudienceButton:anything() forReelId:@(reelId)];
            [verify(userProfilePresenter) requestedAudienceMembersForReelId:@(reelId)];
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
            description = [RTReelDescription reelDescriptionWithName:@"buzz"
                                                           forReelId:@(reelId)
                                                        audienceSize:@(1)
                                                      numberOfVideos:@(2)
                                       currentUserIsAnAudienceMember:@(YES)
                                                       ownerUsername:username];
            
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
        
        context(@"data source contains reel description", ^{
            beforeEach(^{
                viewController.reelsDataSource.items = @[description];
            });
            
            describe(@"reel header", ^{
                __block RTUserReelHeaderView *headerView;
                
                __block UILabel *reelNameLabel;
                __block UILabel *videoCountLabel;
                
                beforeEach(^{
                    reelNameLabel = [[UILabel alloc] init];
                    videoCountLabel = [[UILabel alloc] init];
                    
                    headerView = [[RTUserReelHeaderView alloc] init];
                    headerView.reelNameLabel = reelNameLabel;
                    headerView.videoCountLabel = videoCountLabel;
                    
                    [given([tableView dequeueReusableHeaderFooterViewWithIdentifier:@"UserReelHeader"]) willReturn:headerView];
                });
                
                it(@"should return header view", ^{
                    UIView *view = [viewController tableView:tableView viewForHeaderInSection:0];
                    expect(view).to.beIdenticalTo(headerView);
                });
                
                it(@"should set the reel name label based on description", ^{
                    [viewController tableView:tableView viewForHeaderInSection:0];
                    expect(headerView.reelNameLabel.text).to.equal(@"buzz");
                });
                
                it(@"zero videos", ^{
                    description.numberOfVideos = @(0);
                    
                    [viewController tableView:tableView viewForHeaderInSection:0];
                    expect(headerView.videoCountLabel.text).to.equal(@"0 Videos");
                });
                
                it(@"one video", ^{
                    description.numberOfVideos = @(1);
                    
                    [viewController tableView:tableView viewForHeaderInSection:0];
                    expect(headerView.videoCountLabel.text).to.equal(@"1 Video");
                });
                
                it(@"multiple videos", ^{
                    description.numberOfVideos = @(2);
                    
                    [viewController tableView:tableView viewForHeaderInSection:0];
                    expect(headerView.videoCountLabel.text).to.equal(@"2 Videos");
                });
            });

            describe(@"reel footer", ^{
                __block RTUserReelFooterView *footerView;
                
                __block UIButton *followReelButton;
                __block UIButton *listAudienceButton;
 
                beforeEach(^{
                    followReelButton = [[UIButton alloc] init];
                    listAudienceButton = [[UIButton alloc] init];

                    footerView = [[RTUserReelFooterView alloc] init];
                    footerView.followReelButton = followReelButton;
                    footerView.listAudienceButton = listAudienceButton;
                    
                    [given([tableView dequeueReusableHeaderFooterViewWithIdentifier:@"UserReelFooter"]) willReturn:footerView];
                });
                
                it(@"should set properties that do not depend on description", ^{
                    UIView *view = [viewController tableView:tableView viewForFooterInSection:0];
                    expect(view).to.beIdenticalTo(footerView);
                    
                    expect(footerView.delegate).to.equal(viewController);
                    expect(footerView.reelId).to.equal(@(reelId));
                });
                
                it(@"current user is not an audience member", ^{
                    description.currentUserIsAnAudienceMember = @(NO);
                    
                    [viewController tableView: tableView viewForFooterInSection:0];
                    expect(footerView.followReelButton.titleLabel.text).to.equal(@"Follow Reel");
                });
                
                it(@"current user is an audience member", ^{
                    description.currentUserIsAnAudienceMember = @(YES);
                    
                    [viewController tableView: tableView viewForFooterInSection:0];
                    expect(footerView.followReelButton.titleLabel.text).to.equal(@"Unfollow Reel");
                });
                
                it(@"zero followers", ^{
                    description.audienceSize = @(0);
                    
                    [viewController tableView: tableView viewForFooterInSection:0];
                    expect(footerView.listAudienceButton.titleLabel.text).to.equal(@"0 Followers");
                });
                
                it(@"one follower", ^{
                    description.audienceSize = @(1);

                    [viewController tableView:tableView viewForFooterInSection:0];
                    expect(footerView.listAudienceButton.titleLabel.text).to.equal(@"1 Follower");
                });
                
                it(@"multiple followers", ^{
                    description.audienceSize = @(2);
                    
                    [viewController tableView:tableView viewForFooterInSection:0];
                    expect(footerView.listAudienceButton.titleLabel.text).to.equal(@"2 Followers");
                });
            });
        });
    });
});

SpecEnd