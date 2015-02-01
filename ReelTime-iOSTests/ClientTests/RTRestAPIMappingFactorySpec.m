#import "RTTestCommon.h"
#import "RTRestAPIMappingFactory.h"

#import "RTOAuth2Token.h"
#import "RTOAuth2TokenError.h"

#import "RTServerErrors.h"
#import "RTClientCredentials.h"

#import "RTActivity.h"
#import "RTUser.h"
#import "RTReel.h"
#import "RTVideo.h"

#import <RestKit/Testing.h>

SpecBegin(RTRestAPIMappingFactory)

describe(@"API Mapping", ^{
    
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
        NSDictionary *response = @{
                                   @"username": @"someone",
                                   @"display_name": @"some display",
                                   @"follower_count": @(42),
                                   @"followee_count": @(87)
                                   };
        
        RTUser *user = [[RTUser alloc] init];
        RKMappingTest *mappingTest = [RKMappingTest testForMapping:mapping
                                                      sourceObject:response
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
        
        [mappingTest performMapping];
        [mappingTest verify];
    });
    
    it(@"reel", ^{
        RKMapping *mapping = [RTRestAPIMappingFactory reelMapping];
        NSDictionary *response = @{
                                   @"reel_id": @(12),
                                   @"name": @"some reel",
                                   @"audience_size": @(2),
                                   @"video_count": @(20)
                                   };
        
        RTReel *reel = [[RTReel alloc] init];
        RKMappingTest *mappingTest = [RKMappingTest testForMapping:mapping
                                                      sourceObject:response
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
        
        [mappingTest performMapping];
        [mappingTest verify];
    });
    
    it(@"video", ^{
        RKMapping *mapping = [RTRestAPIMappingFactory videoMapping];
        NSDictionary *response = @{
                                   @"video_id": @(72),
                                   @"title": @"some video"
                                   };
        
        RTVideo *video = [[RTVideo alloc] init];
        RKMappingTest *mappingTest = [RKMappingTest testForMapping:mapping
                                                      sourceObject:response
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

    xdescribe(@"newsfeed activities", ^{
       
        it(@"create reel activity" , ^{
            RKMapping *mapping = [RTRestAPIMappingFactory activityMapping];
            NSDictionary *response = @{
                                       @"type": @"create-reel",
                                       @"user": @{
                                               @"username": @"someone",
                                               @"display_name": @"some display",
                                               @"follower_count": @(42),
                                               @"followee_count": @(87)
                                               },
                                       @"reel": @{
                                               @"reel_id": @(12),
                                               @"name": @"some reel",
                                               @"audience_size": @(2),
                                               @"video_count": @(20)
                                               }
                                       };
            
            RTActivity *activity = [[RTActivity alloc] init];
            activity.user = [[RTUser alloc] init];
            activity.reel = [[RTReel alloc] init];

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
    });
});

SpecEnd