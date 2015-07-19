#import "RTTestCommon.h"
#import "RTRestAPIMappingFactory.h"

#import "RTOAuth2Token.h"
#import "RTOAuth2TokenError.h"

#import "RTServerErrors.h"
#import "RTClientCredentials.h"

#import "RTClient.h"
#import "RTClientList.h"

#import "RTUser.h"
#import "RTUserList.h"

#import "RTReel.h"
#import "RTReelList.h"

#import "RTVideo.h"
#import "RTVideoList.h"

#import "RTActivity.h"
#import "RTNewsfeed.h"

#import <RestKit/Testing.h>

SpecBegin(RTRestAPIMappingFactory)

describe(@"API Mapping", ^{

    __block NSDictionary *clientResponse1 = @{
                                              @"client_id": @"cid1",
                                              @"client_name": @"client1"
                                              };
    
    __block NSDictionary *clientResponse2 = @{
                                              @"client_id": @"cid2",
                                              @"client_name": @"client2"
                                              };
   
    __block NSDictionary *userResponse1 = @{
                                           @"username": @"someone",
                                           @"display_name": @"some display",
                                           @"follower_count": @(42),
                                           @"followee_count": @(87),
                                           @"reel_count": @(34),
                                           @"audience_membership_count": @(19),
                                           @"current_user_is_following": @(YES)
                                           };
    
    __block NSDictionary *userResponse2 = @{
                                            @"username": @"anyone",
                                            @"display_name": @"any display",
                                            @"follower_count": @(51),
                                            @"followee_count": @(98),
                                            @"reel_count": @(26),
                                            @"audience_membership_count": @(83),
                                            @"current_user_is_following": @(NO)
                                            };
    
    __block NSDictionary *reelResponse1 = @{
                                           @"reel_id": @(12),
                                           @"name": @"some reel",
                                           @"audience_size": @(2),
                                           @"video_count": @(20),
                                           @"owner": userResponse1,
                                           @"current_user_is_an_audience_member": @(YES)
                                           };

    __block NSDictionary *reelResponse2 = @{
                                            @"reel_id": @(94),
                                            @"name": @"any reel",
                                            @"audience_size": @(3),
                                            @"video_count": @(81),
                                            @"owner": userResponse2,
                                            @"current_user_is_an_audience_member": @(NO)
                                            };

    __block NSDictionary *videoResponse1 = @{
                                            @"video_id": @(72),
                                            @"title": @"some video"
                                            };

    __block NSDictionary *videoResponse2 = @{
                                             @"video_id": @(31),
                                             @"title": @"any video"
                                             };
   
    it(@"token", ^{
        RKMapping *mapping = [RTRestAPIMappingFactory tokenMapping];
        NSDictionary *response = @{
                                   @"access_token": @"1d49fc35-2af6-477e-8fd4-ab0353a4a76f",
                                   @"token_type": @"bearer",
                                   @"refresh_token": @"4996ba33-be3f-4555-b3e3-0b094a4e60c0",
                                   @"expires_in": @"43199",
                                   @"scope": @"read"
                                   };
        
        RTOAuth2Token *token = [[RTOAuth2Token alloc] init];
        RKMappingTest *mappingTest = [RKMappingTest testForMapping:mapping
                                                      sourceObject:response
                                                 destinationObject:token];
        
        [mappingTest addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"access_token"
                                                                                destinationKeyPath:@"accessToken"
                                                                                             value:@"1d49fc35-2af6-477e-8fd4-ab0353a4a76f"]];
        
        [mappingTest addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"token_type"
                                                                                destinationKeyPath:@"tokenType"
                                                                                             value:@"bearer"]];
        
        [mappingTest addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"refresh_token"
                                                                                destinationKeyPath:@"refreshToken"
                                                                                             value:@"4996ba33-be3f-4555-b3e3-0b094a4e60c0"]];
        
        [mappingTest addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"expires_in"
                                                                                destinationKeyPath:@"expiresIn"
                                                                                             value:@43199]];
        
        [mappingTest addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"scope"
                                                                                destinationKeyPath:@"scope"
                                                                                             value:@"read"]];

        [mappingTest performMapping];
        [mappingTest verify];
    });
    
    it(@"token error", ^{
        RKMapping *mapping = [RTRestAPIMappingFactory tokenErrorMapping];
        NSDictionary *response = @{
                                   @"error": @"invalid_client",
                                   @"error_description": @"Bad client credentials"
                                   };
        
        RTOAuth2TokenError *tokenError = [[RTOAuth2TokenError alloc] init];
        RKMappingTest *mappingTest = [RKMappingTest testForMapping:mapping
                                                      sourceObject:response
                                                 destinationObject:tokenError];
        
        [mappingTest addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"error"
                                                                                destinationKeyPath:@"errorCode"
                                                                                             value:@"invalid_client"]];
        
        [mappingTest addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"error_description"
                                                                                destinationKeyPath:@"errorDescription"
                                                                                             value:@"Bad client credentials"]];

        [mappingTest performMapping];
        [mappingTest verify];
    });

    it(@"single server error", ^{
        RKMapping *mapping = [RTRestAPIMappingFactory serverErrorsMapping];
        NSDictionary *response = @{
                                   @"errors": @[@"single error"]
                                   };
        
        RTServerErrors *serverErrors = [[RTServerErrors alloc] init];
        RKMappingTest *mappingTest = [RKMappingTest testForMapping:mapping
                                                      sourceObject:response
                                                 destinationObject:serverErrors];
        
        [mappingTest addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"errors"
                                                                                destinationKeyPath:@"errors"
                                                                                             value:@[@"single error"]]];
        
        [mappingTest performMapping];
        [mappingTest verify];
    });
    
    it(@"multiple server errors", ^{
        RKMapping *mapping = [RTRestAPIMappingFactory serverErrorsMapping];
        NSDictionary *response = @{
                                   @"errors": @[@"first error", @"second error", @"third error"]
                                   };
        
        RTServerErrors *serverErrors = [[RTServerErrors alloc] init];
        RKMappingTest *mappingTest = [RKMappingTest testForMapping:mapping
                                                      sourceObject:response
                                                 destinationObject:serverErrors];
        
        [mappingTest addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"errors"
                                                                                destinationKeyPath:@"errors"
                                                                                             value:@[
                                                                                                     @"first error",
                                                                                                     @"second error",
                                                                                                     @"third error"
                                                                                                     ]]];
        [mappingTest performMapping];
        [mappingTest verify];
    });
    
    it(@"client", ^{
        RKMapping *mapping = [RTRestAPIMappingFactory clientMapping];
        NSDictionary *response = @{
                                   @"client_id": @"5bdee758-cf71-4cd5-9bd9-aded45ce9964",
                                   @"client_name": @"iPhone 6"
                                   };
        
        RTClient *client = [[RTClient alloc] init];
        RKMappingTest *mappingTest = [RKMappingTest testForMapping:mapping
                                                      sourceObject:response
                                                 destinationObject:client];
        
        [mappingTest addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"client_id"
                                                                                destinationKeyPath:@"clientId"
                                                                                             value:@"5bdee758-cf71-4cd5-9bd9-aded45ce9964"]];
        
        [mappingTest addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"client_name"
                                                                                destinationKeyPath:@"clientName"
                                                                                             value:@"iPhone 6"]];
        
        [mappingTest performMapping];
        [mappingTest verify];
    });
    
    describe(@"client list", ^{
        it(@"no clients in list", ^{
            RKMapping *mapping = [RTRestAPIMappingFactory clientListMapping];
            NSDictionary *response = @{@"clients": @[]};
            
            RTClientList *clientList = [[RTClientList alloc] init];
            RKMappingTest *mappingTest = [RKMappingTest testForMapping:mapping
                                                          sourceObject:response
                                                     destinationObject:clientList];
            
            [mappingTest addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"clients"
                                                                                    destinationKeyPath:@"clients"
                                                                                                 value:@[]]];
            [mappingTest performMapping];
            [mappingTest verify];
        });
        
        it(@"has one client in list", ^{
            RKMapping *mapping = [RTRestAPIMappingFactory clientListMapping];
            NSDictionary *response = @{@"clients": @[clientResponse1]};
            
            RTClientList *clientList = [[RTClientList alloc] init];
            RKMappingTest *mappingTest = [RKMappingTest testForMapping:mapping
                                                          sourceObject:response
                                                     destinationObject:clientList];
            
            [mappingTest addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"clients"
                                                                                    destinationKeyPath:@"clients"]];
            
            [mappingTest performMapping];
            [mappingTest verify];
            
            expect(clientList.clients).to.haveCountOf(1);
            
            RTClient *first = clientList.clients[0];
            expect(first.clientId).to.equal(clientResponse1[@"client_id"]);
            expect(first.clientName).to.equal(clientResponse1[@"client_name"]);
        });
        
        it(@"has multiple users in list", ^{
            RKMapping *mapping = [RTRestAPIMappingFactory clientListMapping];
            NSDictionary *response = @{@"clients": @[clientResponse1, clientResponse2]};
            
            RTClientList *clientList = [[RTClientList alloc] init];
            RKMappingTest *mappingTest = [RKMappingTest testForMapping:mapping
                                                          sourceObject:response
                                                     destinationObject:clientList];
            
            [mappingTest addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"clients"
                                                                                    destinationKeyPath:@"clients"]];
            
            [mappingTest performMapping];
            [mappingTest verify];
            
            expect(clientList.clients).to.haveCountOf(2);
            
            RTClient *first = clientList.clients[0];
            expect(first.clientId).to.equal(clientResponse1[@"client_id"]);
            expect(first.clientName).to.equal(clientResponse1[@"client_name"]);
            
            RTClient *second = clientList.clients[1];
            expect(second.clientId).to.equal(clientResponse2[@"client_id"]);
            expect(second.clientName).to.equal(clientResponse2[@"client_name"]);
        });
    });
    
    it(@"client credentials", ^{
        RKMapping *mapping = [RTRestAPIMappingFactory clientCredentialsMapping];
        NSDictionary *response = @{
                                   @"client_id": @"5bdee758-cf71-4cd5-9bd9-aded45ce9964",
                                   @"client_secret": @"g70mC9ZbpKa6p6R1tJPVWTm55BWHnSkmCv27F=oSI6"
                                   };
        
        RTClientCredentials *clientCredentials = [[RTClientCredentials alloc] init];
        RKMappingTest *mappingTest = [RKMappingTest testForMapping:mapping
                                                      sourceObject:response
                                                 destinationObject:clientCredentials];
        
        [mappingTest addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"client_id"
                                                                                destinationKeyPath:@"clientId"
                                                                                             value:@"5bdee758-cf71-4cd5-9bd9-aded45ce9964"]];
        
        [mappingTest addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"client_secret"
                                                                                destinationKeyPath:@"clientSecret"
                                                                                             value:@"g70mC9ZbpKa6p6R1tJPVWTm55BWHnSkmCv27F=oSI6"]];
        
        [mappingTest performMapping];
        [mappingTest verify];
    });
    
    it(@"user", ^{
        RKMapping *mapping = [RTRestAPIMappingFactory userMapping];
        
        RTUser *user = [[RTUser alloc] init];
        RKMappingTest *mappingTest = [RKMappingTest testForMapping:mapping
                                                      sourceObject:userResponse1
                                                 destinationObject:user];
        
        [mappingTest addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"username"
                                                                                destinationKeyPath:@"username"
                                                                                             value:@"someone"]];
        
        [mappingTest addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"display_name"
                                                                                destinationKeyPath:@"displayName"
                                                                                             value:@"some display"]];
        
        [mappingTest addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"follower_count"
                                                                                destinationKeyPath:@"numberOfFollowers"
                                                                                             value:@(42)]];
        
        [mappingTest addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"followee_count"
                                                                                destinationKeyPath:@"numberOfFollowees"
                                                                                             value:@(87)]];
        
        [mappingTest addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"reel_count"
                                                                                destinationKeyPath:@"numberOfReelsOwned"
                                                                                             value:@(34)]];
        
        [mappingTest addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"audience_membership_count"
                                                                                destinationKeyPath:@"numberOfAudienceMemberships"
                                                                                             value:@(19)]];
        
        [mappingTest addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"current_user_is_following"
                                                                                destinationKeyPath:@"currentUserIsFollowing"
                                                                                             value:@(YES)]];
        
        [mappingTest performMapping];
        [mappingTest verify];
    });
    
    describe(@"user list", ^{
        it(@"no users in list", ^{
            RKMapping *mapping = [RTRestAPIMappingFactory userListMapping];
            NSDictionary *response = @{@"users": @[]};
            
            RTUserList *userList = [[RTUserList alloc] init];
            RKMappingTest *mappingTest = [RKMappingTest testForMapping:mapping
                                                          sourceObject:response
                                                     destinationObject:userList];
            
            [mappingTest addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"users"
                                                                                    destinationKeyPath:@"users"
                                                                                                 value:@[]]];
            [mappingTest performMapping];
            [mappingTest verify];
        });
        
        it(@"has one user in list", ^{
            RKMapping *mapping = [RTRestAPIMappingFactory userListMapping];
            NSDictionary *response = @{@"users": @[userResponse1]};
            
            RTUserList *userList = [[RTUserList alloc] init];
            RKMappingTest *mappingTest = [RKMappingTest testForMapping:mapping
                                                          sourceObject:response
                                                     destinationObject:userList];
            
            [mappingTest addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"users"
                                                                                    destinationKeyPath:@"users"]];
            
            [mappingTest performMapping];
            [mappingTest verify];
            
            expect(userList.users).to.haveCountOf(1);
            
            RTUser *first = userList.users[0];
            expect(first).to.beUser(userResponse1[@"username"], userResponse1[@"display_name"],
                                    userResponse1[@"follower_count"], userResponse1[@"followee_count"],
                                    userResponse1[@"reel_count"], userResponse1[@"audience_membership_count"],
                                    userResponse1[@"current_user_is_following"]);
        });
        
        it(@"has multiple users in list", ^{
            RKMapping *mapping = [RTRestAPIMappingFactory userListMapping];
            NSDictionary *response = @{@"users": @[userResponse1, userResponse2]};
            
            RTUserList *userList = [[RTUserList alloc] init];
            RKMappingTest *mappingTest = [RKMappingTest testForMapping:mapping
                                                          sourceObject:response
                                                     destinationObject:userList];
            
            [mappingTest addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"users"
                                                                                    destinationKeyPath:@"users"]];
            
            [mappingTest performMapping];
            [mappingTest verify];
            
            expect(userList.users).to.haveCountOf(2);
            
            RTUser *first = userList.users[0];
            expect(first).to.beUser(userResponse1[@"username"], userResponse1[@"display_name"],
                                    userResponse1[@"follower_count"], userResponse1[@"followee_count"],
                                    userResponse1[@"reel_count"], userResponse1[@"audience_membership_count"],
                                    userResponse1[@"current_user_is_following"]);

            RTUser *second = userList.users[1];
            expect(second).to.beUser(userResponse2[@"username"], userResponse2[@"display_name"],
                                     userResponse2[@"follower_count"], userResponse2[@"followee_count"],
                                     userResponse2[@"reel_count"], userResponse2[@"audience_membership_count"],
                                     userResponse2[@"current_user_is_following"]);
        });
    });
    
    it(@"reel", ^{
        RKMapping *mapping = [RTRestAPIMappingFactory reelMapping];
        
        RTReel *reel = [[RTReel alloc] init];
        RKMappingTest *mappingTest = [RKMappingTest testForMapping:mapping
                                                      sourceObject:reelResponse1
                                                 destinationObject:reel];
        
        [mappingTest addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"reel_id"
                                                                                destinationKeyPath:@"reelId"
                                                                                             value:@(12)]];
         
        [mappingTest addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"name"
                                                                                destinationKeyPath:@"name"
                                                                                             value:@"some reel"]];
        
        [mappingTest addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"audience_size"
                                                                                destinationKeyPath:@"audienceSize"
                                                                                             value:@(2)]];
        
        [mappingTest addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"video_count"
                                                                                destinationKeyPath:@"numberOfVideos"
                                                                                             value:@(20)]];

        [mappingTest addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"current_user_is_an_audience_member"
                                                                                destinationKeyPath:@"currentUserIsAnAudienceMember"
                                                                                             value:@(YES)]];
        
        RKMapping *userMapping = [RTRestAPIMappingFactory userMapping];
        [mappingTest addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"owner"
                                                                                destinationKeyPath:@"owner"
                                                                                           mapping:userMapping]];
        
        [mappingTest performMapping];
        [mappingTest verify];
    });
    
    describe(@"reel list", ^{
        it(@"no reels in list", ^{
            RKMapping *mapping = [RTRestAPIMappingFactory reelListMapping];
            NSDictionary *response = @{@"reels": @[]};
            
            RTReelList *reelList = [[RTReelList alloc] init];
            RKMappingTest *mappingTest = [RKMappingTest testForMapping:mapping
                                                          sourceObject:response
                                                     destinationObject:reelList];
            
            [mappingTest addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"reels"
                                                                                    destinationKeyPath:@"reels"
                                                                                                 value:@[]]];
            [mappingTest performMapping];
            [mappingTest verify];
        });
        
        it(@"has one reel in list", ^{
            RKMapping *mapping = [RTRestAPIMappingFactory reelListMapping];
            NSDictionary *response = @{@"reels": @[reelResponse1]};
            
            RTReelList *reelList = [[RTReelList alloc] init];
            RKMappingTest *mappingTest = [RKMappingTest testForMapping:mapping
                                                          sourceObject:response
                                                     destinationObject:reelList];
            
            [mappingTest addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"reels"
                                                                                    destinationKeyPath:@"reels"]];
            
            [mappingTest performMapping];
            [mappingTest verify];
            
            expect(reelList.reels).to.haveCountOf(1);
            
            RTReel *first = reelList.reels[0];
            expect(first).to.beReel(reelResponse1[@"reel_id"], reelResponse1[@"name"],
                                    reelResponse1[@"audience_size"], reelResponse1[@"video_count"],
                                    reelResponse1[@"current_user_is_an_audience_member"]);
            
            expect(first.owner).to.beUser(userResponse1[@"username"], userResponse1[@"display_name"],
                                          userResponse1[@"follower_count"], userResponse1[@"followee_count"],
                                          userResponse1[@"reel_count"], userResponse1[@"audience_membership_count"],
                                          userResponse1[@"current_user_is_following"]);
        });
        
        it(@"has multiple reels in list", ^{
            RKMapping *mapping = [RTRestAPIMappingFactory reelListMapping];
            NSDictionary *response = @{@"reels": @[reelResponse1, reelResponse2]};
            
            RTReelList *reelList = [[RTReelList alloc] init];
            RKMappingTest *mappingTest = [RKMappingTest testForMapping:mapping
                                                          sourceObject:response
                                                     destinationObject:reelList];
            
            [mappingTest addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"reels"
                                                                                    destinationKeyPath:@"reels"]];
            
            [mappingTest performMapping];
            [mappingTest verify];
            
            expect(reelList.reels).to.haveCountOf(2);
            
            RTReel *first = reelList.reels[0];
            expect(first).to.beReel(reelResponse1[@"reel_id"], reelResponse1[@"name"],
                                    reelResponse1[@"audience_size"], reelResponse1[@"video_count"],
                                    reelResponse1[@"current_user_is_an_audience_member"]);

            expect(first.owner).to.beUser(userResponse1[@"username"], userResponse1[@"display_name"],
                                          userResponse1[@"follower_count"], userResponse1[@"followee_count"],
                                          userResponse1[@"reel_count"], userResponse1[@"audience_membership_count"],
                                          userResponse1[@"current_user_is_following"]);
            
            RTReel *second = reelList.reels[1];
            expect(second).to.beReel(reelResponse2[@"reel_id"], reelResponse2[@"name"],
                                     reelResponse2[@"audience_size"], reelResponse2[@"video_count"],
                                     reelResponse2[@"current_user_is_an_audience_member"]);

            expect(second.owner).to.beUser(userResponse2[@"username"], userResponse2[@"display_name"],
                                           userResponse2[@"follower_count"], userResponse2[@"followee_count"],
                                           userResponse2[@"reel_count"], userResponse2[@"audience_membership_count"],
                                           userResponse2[@"current_user_is_following"]);
        });
    });

    it(@"video", ^{
        RKMapping *mapping = [RTRestAPIMappingFactory videoMapping];

        RTVideo *video = [[RTVideo alloc] init];
        RKMappingTest *mappingTest = [RKMappingTest testForMapping:mapping
                                                      sourceObject:videoResponse1
                                                 destinationObject:video];
        
        [mappingTest addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"video_id"
                                                                                destinationKeyPath:@"videoId"
                                                                                             value:@(72)]];
        
        [mappingTest addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"title"
                                                                                destinationKeyPath:@"title"
                                                                                             value:@"some video"]];
        
        [mappingTest performMapping];
        [mappingTest verify];
    });
    
    describe(@"video list", ^{
        it(@"no videos in list", ^{
            RKMapping *mapping = [RTRestAPIMappingFactory videoListMapping];
            NSDictionary *response = @{@"videos": @[]};
            
            RTVideoList *videoList = [[RTVideoList alloc] init];
            RKMappingTest *mappingTest = [RKMappingTest testForMapping:mapping
                                                          sourceObject:response
                                                     destinationObject:videoList];
            
            [mappingTest addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"videos"
                                                                                    destinationKeyPath:@"videos"
                                                                                                 value:@[]]];
            [mappingTest performMapping];
            [mappingTest verify];
        });
        
        it(@"has one video in list", ^{
            RKMapping *mapping = [RTRestAPIMappingFactory videoListMapping];
            NSDictionary *response = @{@"videos": @[videoResponse1]};
            
            RTVideoList *videoList = [[RTVideoList alloc] init];
            RKMappingTest *mappingTest = [RKMappingTest testForMapping:mapping
                                                          sourceObject:response
                                                     destinationObject:videoList];
            
            [mappingTest addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"videos"
                                                                                    destinationKeyPath:@"videos"]];
            
            [mappingTest performMapping];
            [mappingTest verify];
            
            expect(videoList.videos).to.haveCountOf(1);
            
            RTVideo *first = videoList.videos[0];
            expect(first).to.beVideo(videoResponse1[@"video_id"], videoResponse1[@"title"]);
        });

        it(@"has multiple videos in list", ^{
            RKMapping *mapping = [RTRestAPIMappingFactory videoListMapping];
            NSDictionary *response = @{@"videos": @[videoResponse1, videoResponse2]};
            
            RTVideoList *videoList = [[RTVideoList alloc] init];
            RKMappingTest *mappingTest = [RKMappingTest testForMapping:mapping
                                                          sourceObject:response
                                                     destinationObject:videoList];
            
            [mappingTest addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"videos"
                                                                                    destinationKeyPath:@"videos"]];
            
            [mappingTest performMapping];
            [mappingTest verify];
            
            expect(videoList.videos).to.haveCountOf(2);
            
            RTVideo *first = videoList.videos[0];
            expect(first).to.beVideo(videoResponse1[@"video_id"], videoResponse1[@"title"]);
            
            RTVideo *second = videoList.videos[1];
            expect(second).to.beVideo(videoResponse2[@"video_id"], videoResponse2[@"title"]);
        });
    });

    describe(@"newsfeed activities", ^{
        __block NSMutableDictionary *response;
        __block RTActivity *activity;
        
        beforeEach(^{
            response = [[NSMutableDictionary alloc] init];
            
            [response setObject:userResponse1 forKey:@"user"];
            [response setObject:reelResponse1 forKey:@"reel"];

            activity = [[RTActivity alloc] init];

            activity.user = [[RTUser alloc] init];
            activity.reel = [[RTReel alloc] init];
            activity.video = [[RTVideo alloc] init];

        });
       
        it(@"create reel activity" , ^{
            RKMapping *mapping = [RTRestAPIMappingFactory activityMapping];
            [response setObject:@"create-reel" forKey:@"type"];
            
            RKMappingTest *mappingTest = [RKMappingTest testForMapping:mapping
                                                          sourceObject:response
                                                     destinationObject:activity];
            
            [mappingTest addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"type"
                                                                                    destinationKeyPath:@"type"
                                                                                                 value:@(RTActivityTypeCreateReel)]];
            
            RKMapping *userMapping = [RTRestAPIMappingFactory userMapping];
            [mappingTest addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"user"
                                                                                    destinationKeyPath:@"user"
                                                                                               mapping:userMapping]];
            
            RKMapping *reelMapping = [RTRestAPIMappingFactory reelMapping];
            [mappingTest addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"reel"
                                                                                    destinationKeyPath:@"reel"
                                                                                               mapping:reelMapping]];
            
            [mappingTest performMapping];
            [mappingTest verify];
        });
        
        it(@"join reel audience activity", ^{
            RKMapping *mapping = [RTRestAPIMappingFactory activityMapping];
            [response setObject:@"join-reel-audience" forKey:@"type"];
            
            RKMappingTest *mappingTest = [RKMappingTest testForMapping:mapping
                                                          sourceObject:response
                                                     destinationObject:activity];
            
            [mappingTest addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"type"
                                                                                    destinationKeyPath:@"type"
                                                                                                 value:@(RTActivityTypeJoinReelAudience)]];
            
            RKMapping *userMapping = [RTRestAPIMappingFactory userMapping];
            [mappingTest addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"user"
                                                                                    destinationKeyPath:@"user"
                                                                                               mapping:userMapping]];
            
            RKMapping *reelMapping = [RTRestAPIMappingFactory reelMapping];
            [mappingTest addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"reel"
                                                                                    destinationKeyPath:@"reel"
                                                                                               mapping:reelMapping]];
            
            [mappingTest performMapping];
            [mappingTest verify];
        });
        
        it(@"add video to reel activity", ^{
            RKMapping *mapping = [RTRestAPIMappingFactory activityMapping];

            [response setObject:@"add-video-to-reel" forKey:@"type"];
            [response setObject:videoResponse1 forKey:@"video"];
            
            RKMappingTest *mappingTest = [RKMappingTest testForMapping:mapping
                                                          sourceObject:response
                                                     destinationObject:activity];
            
            [mappingTest addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"type"
                                                                                    destinationKeyPath:@"type"
                                                                                                 value:@(RTActivityTypeAddVideoToReel)]];
            
            RKMapping *userMapping = [RTRestAPIMappingFactory userMapping];
            [mappingTest addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"user"
                                                                                    destinationKeyPath:@"user"
                                                                                               mapping:userMapping]];
            
            RKMapping *reelMapping = [RTRestAPIMappingFactory reelMapping];
            [mappingTest addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"reel"
                                                                                    destinationKeyPath:@"reel"
                                                                                               mapping:reelMapping]];
            
            RKMapping *videoMapping = [RTRestAPIMappingFactory videoMapping];
            [mappingTest addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"video"
                                                                                    destinationKeyPath:@"video"
                                                                                                 mapping:videoMapping]];
            
            [mappingTest performMapping];
            [mappingTest verify];
        });

    });
    
    describe(@"newsfeed", ^{
        it(@"no activities in newsfeed", ^{
            RKMapping *mapping = [RTRestAPIMappingFactory newsfeedMapping];
            NSDictionary *response = @{
                                       @"activities": @[]
                                       };
            
            RTNewsfeed *newsfeed = [[RTNewsfeed alloc] init];
            RKMappingTest *mappingTest = [RKMappingTest testForMapping:mapping
                                                          sourceObject:response
                                                     destinationObject:newsfeed];
            
            [mappingTest addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"activities"
                                                                                    destinationKeyPath:@"activities"
                                                                                                 value:@[]]];
            
            [mappingTest performMapping];
            [mappingTest verify];
        });
        
        it(@"activity in newsfeed", ^{
            RKMapping *mapping = [RTRestAPIMappingFactory newsfeedMapping];
            NSMutableDictionary *activity = [[NSMutableDictionary alloc] init];

            [activity setObject:@"create-reel" forKey:@"type"];
            [activity setObject:userResponse1 forKey:@"user"];
            [activity setObject:reelResponse1 forKey:@"reel"];

            NSMutableDictionary *response = [[NSMutableDictionary alloc] init];
            [response setObject:@[activity] forKey:@"activities"];
            
            RTNewsfeed *newsfeed = [[RTNewsfeed alloc] init];
            RKMappingTest *mappingTest = [RKMappingTest testForMapping:mapping
                                                          sourceObject:response
                                                     destinationObject:newsfeed];
            
            [mappingTest addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"activities"
                                                                                    destinationKeyPath:@"activities"]];
            
            [mappingTest performMapping];
            [mappingTest verify];
            
            expect([newsfeed.activities count]).to.equal(1);

            RTActivity *first = [newsfeed.activities objectAtIndex:0];
            expect(first.type).to.equal(@(RTActivityTypeCreateReel));
            
            expect([first.user class]).to.equal([RTUser class]);
            expect(first.user.username).to.equal([userResponse1 objectForKey:@"username"]);

            expect([first.reel class]).to.equal([RTReel class]);
            expect(first.reel.name).to.equal([reelResponse1 objectForKey:@"name"]);

            expect(first.video).to.beNil();
        });
        
        it(@"multiple activites in newsfeed", ^{
            RKMapping *mapping = [RTRestAPIMappingFactory newsfeedMapping];

            NSMutableDictionary *firstActivity = [[NSMutableDictionary alloc] init];

            [firstActivity setObject:@"create-reel" forKey:@"type"];
            [firstActivity setObject:userResponse1 forKey:@"user"];
            [firstActivity setObject:reelResponse1 forKey:@"reel"];
            
            NSMutableDictionary *secondActivity = [[NSMutableDictionary alloc] init];
            
            [secondActivity setObject:@"add-video-to-reel" forKey:@"type"];
            [secondActivity setObject:userResponse1 forKey:@"user"];
            [secondActivity setObject:reelResponse1 forKey:@"reel"];
            [secondActivity setObject:videoResponse1 forKey:@"video"];
            
            NSMutableDictionary *response = [[NSMutableDictionary alloc] init];
            [response setObject:@[firstActivity, secondActivity] forKey:@"activities"];
            
            RTNewsfeed *newsfeed = [[RTNewsfeed alloc] init];
            RKMappingTest *mappingTest = [RKMappingTest testForMapping:mapping
                                                          sourceObject:response
                                                     destinationObject:newsfeed];
            
            [mappingTest addExpectation:[RKPropertyMappingTestExpectation expectationWithSourceKeyPath:@"activities"
                                                                                    destinationKeyPath:@"activities"]];
            
            [mappingTest performMapping];
            [mappingTest verify];
            
            expect([newsfeed.activities count]).to.equal(2);
            
            RTActivity *first = [newsfeed.activities objectAtIndex:0];
            expect(first.type).to.equal(@(RTActivityTypeCreateReel));
            
            expect([first.user class]).to.equal([RTUser class]);
            expect(first.user.username).to.equal([userResponse1 objectForKey:@"username"]);
            
            expect([first.reel class]).to.equal([RTReel class]);
            expect(first.reel.name).to.equal([reelResponse1 objectForKey:@"name"]);
            
            expect(first.video).to.beNil();
            
            RTActivity *second = [newsfeed.activities objectAtIndex:1];
            expect(second.type).to.equal(@(RTActivityTypeAddVideoToReel));
            
            expect([second.user class]).to.equal([RTUser class]);
            expect(second.user.username).to.equal([userResponse1 objectForKey:@"username"]);
            
            expect([second.reel class]).to.equal([RTReel class]);
            expect(second.reel.name).to.equal([reelResponse1 objectForKey:@"name"]);
            
            expect([second.video class]).to.equal([RTVideo class]);
            expect(second.video.title).to.equal([videoResponse1 objectForKey:@"title"]);
        });
    });
});

SpecEnd