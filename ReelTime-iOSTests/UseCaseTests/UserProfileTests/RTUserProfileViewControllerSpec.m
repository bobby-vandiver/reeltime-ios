#import "RTTestCommon.h"

#import "RTUserProfileViewController.h"
#import "RTArrayDataSource.h"

#import "RTUserProfilePresenter.h"
#import "RTUserSummaryPresenter.h"

#import "RTBrowseReelsPresenter.h"
#import "RTBrowseVideosPresenter.h"

#import "RTFollowUserPresenter.h"
#import "RTUnfollowUserPresenter.h"

#import "RTJoinAudiencePresenter.h"
#import "RTLeaveAudiencePresenter.h"

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
@property NSNumber *numberOfFollowers;

@end

@interface RTUserDescription (Test)

@property (readwrite) NSNumber *currentUserIsFollowing;

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

    __block RTFollowUserPresenter *followUserPresenter;
    __block RTUnfollowUserPresenter *unfollowUserPresenter;
    
    __block RTJoinAudiencePresenter *joinAudiencePresenter;
    __block RTLeaveAudiencePresenter *leaveAudiencePresenter;
    
    __block id<RTBrowseReelVideosPresenterFactory> reelVideosPresenterFactory;
    __block id<RTVideoWireframe> reelVideosWireframe;
    
    __block RTThumbnailSupport *thumbnailSupport;
    __block RTCurrentUserService *currentUserService;

    __block UILabel *usernameLabel;
    __block UILabel *displayNameLabel;
    
    __block UIButton *subscribersButton;
    __block UIButton *subscribedToButton;
    
    __block UILabel *reelsCreatedLabel;
    __block UILabel *reelsFollowingLabel;
 
    __block UIButton *settingsOrFollowUserButton;
    __block UITableView *tableView;
    
    beforeEach(^{
        userProfilePresenter = mock([RTUserProfilePresenter class]);
        userSummaryPresenter = mock([RTUserSummaryPresenter class]);
        reelsPresenter = mock([RTBrowseReelsPresenter class]);
        
        followUserPresenter = mock([RTFollowUserPresenter class]);
        unfollowUserPresenter = mock([RTUnfollowUserPresenter class]);

        joinAudiencePresenter = mock([RTJoinAudiencePresenter class]);
        leaveAudiencePresenter = mock([RTLeaveAudiencePresenter class]);
 
        reelVideosPresenterFactory = mockProtocol(@protocol(RTBrowseReelVideosPresenterFactory));
        reelVideosWireframe = mockProtocol(@protocol(RTVideoWireframe));
        
        thumbnailSupport = mock([RTThumbnailSupport class]);
        currentUserService = mock([RTCurrentUserService class]);
 
        viewController = [RTUserProfileViewController viewControllerForUsername:username
                                                       withUserProfilePresenter:userProfilePresenter
                                                           userSummaryPresenter:userSummaryPresenter
                                                                 reelsPresenter:reelsPresenter
                                                            followUserPresenter:followUserPresenter
                                                          unfollowUserPresenter:unfollowUserPresenter
                                                          joinAudiencePresenter:joinAudiencePresenter
                                                         leaveAudiencePresenter:leaveAudiencePresenter
                                                     reelVideosPresenterFactory:reelVideosPresenterFactory
                                                            reelVideosWireframe:reelVideosWireframe
                                                               thumbnailSupport:thumbnailSupport
                                                             currentUserService:currentUserService];
        
        usernameLabel = [[UILabel alloc] init];
        displayNameLabel = [[UILabel alloc] init];
        
        subscribersButton = [[UIButton alloc] init];
        subscribedToButton = [[UIButton alloc] init];
        
        reelsCreatedLabel = [[UILabel alloc] init];
        reelsFollowingLabel = [[UILabel alloc] init];

        settingsOrFollowUserButton = [[UIButton alloc] init];
        tableView = mock([UITableView class]);
        
        viewController.usernameLabel = usernameLabel;
        viewController.displayNameLabel = displayNameLabel;
        
        viewController.subscribersButton = subscribersButton;
        viewController.subscribedToButton = subscribedToButton;
        
        viewController.reelsCreatedLabel = reelsCreatedLabel;
        viewController.reelsFollowingLabel = reelsFollowingLabel;
        
        viewController.settingsOrFollowUserButton = settingsOrFollowUserButton;
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
    
    describe(@"pressing subscribers button", ^{
        it(@"should present followers for user", ^{
            [viewController pressedSubscribersButton];
            [verify(userProfilePresenter) requestedFollowersForUsername:username];
        });
    });
    
    describe(@"pressings subscribed to button", ^{
        it(@"should present followees for user", ^{
            [viewController pressedSubscribedToButton];
            [verify(userProfilePresenter) requestedFolloweesForUsername:username];
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
                                                numberOfAudienceMemberships:@(4)
                                                     currentUserIsFollowing:@(NO)];
        });
        
        describe(@"show user summary", ^{
            beforeEach(^{
                [viewController showUserDescription:description];
            });
            
            it(@"should update labels with user info", ^{
                expect(viewController.usernameLabel.text).equal(@"Username: foo");
                expect(viewController.displayNameLabel.text).equal(@"Display name: bar");
                
                expect(viewController.subscribersButton.titleLabel.text).equal(@"Subscribers: 1");
                expect(viewController.subscribedToButton.titleLabel.text).equal(@"Subscribed to: 2");
                
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
                expect(viewController.settingsOrFollowUserButton.titleLabel.text).to.equal(@"Settings");
            });
            
            describe(@"pressing settings button", ^{
                it(@"should request settings", ^{
                    [viewController pressedSettingsOrFollowUserButton];
                    [verify(userProfilePresenter) requestedAccountSettings];
                });
            });
        });
        
        context(@"profile is not for currently logged in user", ^{
            beforeEach(^{
                [given([currentUserService currentUsername]) willReturn:@"notFoo"];
            });
            
            context(@"current user is following", ^{
                beforeEach(^{
                    description.currentUserIsFollowing = @(YES);
                    [viewController showUserDescription:description];
                });
                
                it(@"should display unfollow button", ^{
                    expect(viewController.settingsOrFollowUserButton.titleLabel.text).to.equal(@"Unfollow");
                });
                
                describe(@"pressing unfollow button", ^{
                    it(@"should request unfollowing", ^{
                        [viewController pressedSettingsOrFollowUserButton];
                        [verify(unfollowUserPresenter) requestedUserUnfollowingForUsername:username];
                    });
                });
                
                describe(@"showing user as not being followed", ^{
                    beforeEach(^{
                        viewController.numberOfFollowers = @(1);
                        [viewController showUserAsUnfollowedForUsername:@"notFoo"];
                    });
                    
                    it(@"should change unfollow to follow", ^{
                        expect(viewController.settingsOrFollowUserButton.titleLabel.text).to.equal(@"Follow");
                    });
                    
                    it(@"should update subscribers to reflect loss of a follower", ^{
                        expect(viewController.numberOfFollowers).to.equal(@(0));
                        expect(viewController.subscribersButton.titleLabel.text).to.equal(@"Subscribers: 0");
                    });
                });
            });
            
            context(@"current user is not following", ^{
                beforeEach(^{
                    description.currentUserIsFollowing = @(NO);
                    [viewController showUserDescription:description];
                });
                
                it(@"should display follow button", ^{
                    expect(viewController.settingsOrFollowUserButton.titleLabel.text).to.equal(@"Follow");
                });
                
                describe(@"pressing follow button", ^{
                    it(@"should request following", ^{
                        [viewController pressedSettingsOrFollowUserButton];
                        [verify(followUserPresenter) requestedUserFollowingForUsername:username];
                    });
                });
                
                describe(@"showing user as being followed", ^{
                    beforeEach(^{
                        viewController.numberOfFollowers = @(0);
                        [viewController showUserAsFollowedForUsername:@"notFoo"];
                    });
                    
                    it(@"should change follow to unfollow", ^{
                        expect(viewController.settingsOrFollowUserButton.titleLabel.text).to.equal(@"Unfollow");
                    });
                    
                    it(@"should update subscribers to reflect new follower", ^{
                        expect(viewController.numberOfFollowers).to.equal(@(1));
                        expect(viewController.subscribersButton.titleLabel.text).to.equal(@"Subscribers: 1");
                    });
                });
            });
        });
    });

    context(@"reel description required", ^{
        __block RTReelDescription *description;
        
        beforeEach(^{
            description = [RTReelDescription reelDescriptionWithName:@"bazz"
                                                           forReelId:@(reelId)
                                                        audienceSize:@(1)
                                                      numberOfVideos:@(2)
                                       currentUserIsAnAudienceMember:@(YES)
                                                       ownerUsername:@"buzz"];
            
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
                    expect(headerView.reelNameLabel.text).to.equal(@"bazz");
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
                
                describe(@"view for footer in section", ^{
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
                    
                    context(@"profile is for currently logged in user", ^{
                        beforeEach(^{
                            [given([currentUserService currentUsername]) willReturn:@"buzz"];
                            [viewController tableView:tableView viewForFooterInSection:0];
                        });
                        
                        it(@"should not display follow button", ^{
                            expect(footerView.followReelButton.hidden).to.beTruthy();
                        });
                    });
                    
                    context(@"profile is not for currently logged in user", ^{
                        beforeEach(^{
                            [given([currentUserService currentUsername]) willReturn:@"notBuzz"];
                            [viewController tableView:tableView viewForFooterInSection:0];
                        });

                        it(@"should display follow button", ^{
                            expect(footerView.followReelButton.hidden).to.beFalsy();
                        });
                    });
                });
                
                describe(@"pressing follow reel button", ^{
                    it(@"should request currently unfollowed reel is followed", ^{
                        description.currentUserIsAnAudienceMember = @(NO);

                        [viewController footerView:footerView didPressFollowReelButton:followReelButton forReelId:@(reelId)];
                        [verify(joinAudiencePresenter) requestedAudienceMembershipForReelId:@(reelId)];
                    });
                    
                    it(@"should request currently followed reel is followed", ^{
                        description.currentUserIsAnAudienceMember = @(YES);
                        
                        [viewController footerView:footerView didPressFollowReelButton:followReelButton forReelId:@(reelId)];
                        [verify(leaveAudiencePresenter) requestedAudienceMembershipLeaveForReelId:@(reelId)];
                    });
                });
                
                describe(@"join audience view", ^{
                    beforeEach(^{
                        description.currentUserIsAnAudienceMember = @(NO);
                        description.audienceSize = @(0);

                        [viewController showAudienceAsJoinedForReelId:@(reelId)];
                    });

                    it(@"should update reel description to indicate audience membership", ^{
                        expect(description.currentUserIsAnAudienceMember).to.beTruthy();
                    });
                    
                    it(@"should update reel description to indicate incremented audience size", ^{
                        expect(description.audienceSize).to.equal(@(1));
                    });
                    
                    it(@"should reload table", ^{
                        [verify(tableView) reloadData];
                    });
                });
                
                describe(@"leave audience view", ^{
                    beforeEach(^{
                        description.currentUserIsAnAudienceMember = @(YES);
                        description.audienceSize = @(1);
                        
                        [viewController showAudienceAsNotJoinedForReelId:@(reelId)];
                    });
                    
                    it(@"should update reel description to indicate lack of audience membership", ^{
                        expect(description.currentUserIsAnAudienceMember).to.beFalsy();
                    });
                    
                    it(@"should update reel description to indicate decremented audience size", ^{
                        expect(description.audienceSize).to.equal(@(0));
                    });
                    
                    it(@"should reload table", ^{
                        [verify(tableView) reloadData];
                    });
                });
            });
        });
    });
});

SpecEnd