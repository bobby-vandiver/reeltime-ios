#import "RTClientAssembly.h"
#import "RTSecureStoreAssembly.h"

#import "RTAPIClient.h"
#import "RTAuthenticationAwareHTTPClientDelegate.h"
#import "RTClientAdditionalConfiguration.h"
#import "RTAuthenticationAwareHTTPClient.h"

#import "RTEndpointPathFormatter.h"
#import "RTResponseDescriptorFactory.h"

#import <RestKit/RestKit.h>

@implementation RTClientAssembly

- (RTAPIClient *)reelTimeClient {
    return [TyphoonDefinition withClass:[RTAPIClient class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(initWithHttpClient:pathFormatter:)
                        parameters:^(TyphoonMethod *initializer) {
                            [initializer injectParameterWith:[self authenticationAwareHTTPClient]];
                            [initializer injectParameterWith:[self endpointPathFormatter]];
        }];
    }];
}

- (RTEndpointPathFormatter *)endpointPathFormatter {
    return [TyphoonDefinition withClass:[RTEndpointPathFormatter class]];
}

- (RTAuthenticationAwareHTTPClient *)authenticationAwareHTTPClient {
    return [TyphoonDefinition withClass:[RTAuthenticationAwareHTTPClient class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(initWithDelegate:restKitObjectManager:)
                        parameters:^(TyphoonMethod *initializer) {
                            [initializer injectParameterWith:[self authenticationAwareHTTPClientDelegate]];
                            [initializer injectParameterWith:[self restKitObjectManager]];
                        }];
    }];
}

- (RTAuthenticationAwareHTTPClientDelegate *)authenticationAwareHTTPClientDelegate {
    return [TyphoonDefinition withClass:[RTAuthenticationAwareHTTPClientDelegate class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(initWithCurrentUserStore:tokenStore:)
                        parameters:^(TyphoonMethod *initializer) {
                            [initializer injectParameterWith:[self.secureStoreAssembly currentUserStore]];
                            [initializer injectParameterWith:[self.secureStoreAssembly tokenStore]];
                        }];
    }];
}

- (RKObjectManager *)restKitObjectManager {
    return [TyphoonDefinition withClass:[RKObjectManager class] configuration:^(TyphoonDefinition *definition) {
        [RTClientAdditionalConfiguration registerEmptyResponseSupport];
        [RTClientAdditionalConfiguration registerPNGResponseSupport];
        
        [definition useInitializer:@selector(managerWithBaseURL:) parameters:^(TyphoonMethod *method) {
            [method injectParameterWith:[self baseUrl]];
        }];
        
        [definition injectMethod:@selector(addResponseDescriptorsFromArray:) parameters:^(TyphoonMethod *method) {
            [method injectParameterWith:@[
                                          [RTResponseDescriptorFactory tokenDescriptor],
                                          [RTResponseDescriptorFactory tokenErrorDescriptor],
                                          [RTResponseDescriptorFactory accountRegistrationDescriptor],
                                          [RTResponseDescriptorFactory accountRegistrationErrorDescriptor],
                                          [RTResponseDescriptorFactory accountRemovalDescriptor],
                                          [RTResponseDescriptorFactory accountRemovalErrorDescriptor],
                                          [RTResponseDescriptorFactory listClientsDescriptor],
                                          [RTResponseDescriptorFactory listClientsErrorDescriptor],
                                          [RTResponseDescriptorFactory clientRegistrationDescriptor],
                                          [RTResponseDescriptorFactory clientRegistrationErrorDescriptor],
                                          [RTResponseDescriptorFactory clientRemovalDescriptor],
                                          [RTResponseDescriptorFactory clientRemovalErrorDescriptor],
                                          [RTResponseDescriptorFactory accountConfirmationDescriptor],
                                          [RTResponseDescriptorFactory accountConfirmationErrorDescriptor],
                                          [RTResponseDescriptorFactory accountConfirmationSendEmailDescriptor],
                                          [RTResponseDescriptorFactory accountConfirmationSendEmailErrorDescriptor],
                                          [RTResponseDescriptorFactory changeDisplayNameDescriptor],
                                          [RTResponseDescriptorFactory changeDisplayNameErrorDescriptor],
                                          [RTResponseDescriptorFactory changePasswordDescriptor],
                                          [RTResponseDescriptorFactory changePasswordErrorDescriptor],
                                          [RTResponseDescriptorFactory resetPasswordForExistingClientDescriptor],
                                          [RTResponseDescriptorFactory resetPasswordForNewClientDescriptor],
                                          [RTResponseDescriptorFactory resetPasswordErrorDescriptor],
                                          [RTResponseDescriptorFactory resetPasswordSendEmailDescriptor],
                                          [RTResponseDescriptorFactory resetPasswordSendEmailErrorDescriptor],
                                          [RTResponseDescriptorFactory newsfeedDescriptor],
                                          [RTResponseDescriptorFactory newsfeedErrorDescriptor],
                                          [RTResponseDescriptorFactory revokeAccessTokenDescriptor],
                                          [RTResponseDescriptorFactory revokeAccessTokenErrorDescriptor],
                                          [RTResponseDescriptorFactory listReelsDescriptor],
                                          [RTResponseDescriptorFactory listReelsErrorDescriptor],
                                          [RTResponseDescriptorFactory addReelDescriptor],
                                          [RTResponseDescriptorFactory addReelErrorDescriptor],
                                          [RTResponseDescriptorFactory getReelDescriptor],
                                          [RTResponseDescriptorFactory getReelErrorDescriptor],
                                          [RTResponseDescriptorFactory deleteReelDescriptor],
                                          [RTResponseDescriptorFactory deleteReelErrorDescriptor],
                                          [RTResponseDescriptorFactory listAudienceMembersDescriptor],
                                          [RTResponseDescriptorFactory listAudienceMembersErrorDescriptor],
                                          [RTResponseDescriptorFactory joinAudienceDescriptor],
                                          [RTResponseDescriptorFactory joinAudienceErrorDescriptor],
                                          [RTResponseDescriptorFactory leaveAudienceDescriptor],
                                          [RTResponseDescriptorFactory leaveAudienceErrorDescriptor],
                                          [RTResponseDescriptorFactory listReelVideosDescriptor],
                                          [RTResponseDescriptorFactory listReelVideosErrorDescriptor],
                                          [RTResponseDescriptorFactory addVideoToReelDescriptor],
                                          [RTResponseDescriptorFactory addVideoToReelErrorDescriptor],
                                          [RTResponseDescriptorFactory removeVideoFromReelDescriptor],
                                          [RTResponseDescriptorFactory removeVideoFromReelErrorDescriptor],
                                          [RTResponseDescriptorFactory listUsersDescriptor],
                                          [RTResponseDescriptorFactory listUsersErrorDescriptor],
                                          [RTResponseDescriptorFactory getUserDescriptor],
                                          [RTResponseDescriptorFactory getUserErrorDescriptor],
                                          [RTResponseDescriptorFactory listUserReelsDescriptor],
                                          [RTResponseDescriptorFactory listUserReelsErrorDescriptor],
                                          [RTResponseDescriptorFactory followUserDescriptor],
                                          [RTResponseDescriptorFactory followUserErrorDescriptor],
                                          [RTResponseDescriptorFactory unfollowUserDescriptor],
                                          [RTResponseDescriptorFactory unfollowUserErrorDescriptor],
                                          [RTResponseDescriptorFactory listFollowersDescriptor],
                                          [RTResponseDescriptorFactory listFollowersErrorDescriptor],
                                          [RTResponseDescriptorFactory listFolloweesDescriptor],
                                          [RTResponseDescriptorFactory listFolloweesErrorDescriptor],
                                          [RTResponseDescriptorFactory listVideosDescriptor],
                                          [RTResponseDescriptorFactory listVideosErrorDescriptor],
                                          [RTResponseDescriptorFactory addVideoDescriptor],
                                          [RTResponseDescriptorFactory addVideoErrorDescriptor],
                                          [RTResponseDescriptorFactory getVideoDescriptor],
                                          [RTResponseDescriptorFactory getVideoErrorDescriptor],
                                          [RTResponseDescriptorFactory deleteVideoDescriptor],
                                          [RTResponseDescriptorFactory deleteVideoErrorDescriptor],
                                          [RTResponseDescriptorFactory getThumbnailDescriptor]
                                          ]];
        }];
    }];
}

// TODO: Make baseUrl configurable
- (NSURL *)baseUrl {
    return [TyphoonDefinition withClass:[NSURL class] configuration:^(TyphoonDefinition *definition) {
        [definition useInitializer:@selector(URLWithString:) parameters:^(TyphoonMethod *initializer) {
//            [initializer injectParameterWith:@"http://localhost:4567/"];
            [initializer injectParameterWith:@"http://localhost:8080/reeltime/"];
        }];
    }];
}

@end
