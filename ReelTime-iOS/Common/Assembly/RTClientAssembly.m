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
                                          [RTResponseDescriptorFactory accountRemovalTokenErrorDescriptor],
                                          [RTResponseDescriptorFactory listClientsDescriptor],
                                          [RTResponseDescriptorFactory listClientsErrorDescriptor],
                                          [RTResponseDescriptorFactory listClientsTokenErrorDescriptor],
                                          [RTResponseDescriptorFactory clientRegistrationDescriptor],
                                          [RTResponseDescriptorFactory clientRegistrationErrorDescriptor],
                                          [RTResponseDescriptorFactory clientRemovalDescriptor],
                                          [RTResponseDescriptorFactory clientRemovalErrorDescriptor],
                                          [RTResponseDescriptorFactory clientRemovalTokenErrorDescriptor],
                                          [RTResponseDescriptorFactory accountConfirmationDescriptor],
                                          [RTResponseDescriptorFactory accountConfirmationErrorDescriptor],
                                          [RTResponseDescriptorFactory accountConfirmationTokenErrorDescriptor],
                                          [RTResponseDescriptorFactory accountConfirmationSendEmailDescriptor],
                                          [RTResponseDescriptorFactory accountConfirmationSendEmailErrorDescriptor],
                                          [RTResponseDescriptorFactory accountConfirmationSendEmailTokenErrorDescriptor],
                                          [RTResponseDescriptorFactory changeDisplayNameDescriptor],
                                          [RTResponseDescriptorFactory changeDisplayNameErrorDescriptor],
                                          [RTResponseDescriptorFactory changeDisplayNameTokenErrorDescriptor],
                                          [RTResponseDescriptorFactory changePasswordDescriptor],
                                          [RTResponseDescriptorFactory changePasswordErrorDescriptor],
                                          [RTResponseDescriptorFactory changePasswordTokenErrorDescriptor],
                                          [RTResponseDescriptorFactory resetPasswordForExistingClientDescriptor],
                                          [RTResponseDescriptorFactory resetPasswordForNewClientDescriptor],
                                          [RTResponseDescriptorFactory resetPasswordErrorDescriptor],
                                          [RTResponseDescriptorFactory resetPasswordSendEmailDescriptor],
                                          [RTResponseDescriptorFactory resetPasswordSendEmailErrorDescriptor],
                                          [RTResponseDescriptorFactory newsfeedDescriptor],
                                          [RTResponseDescriptorFactory newsfeedErrorDescriptor],
                                          [RTResponseDescriptorFactory newsfeedTokenErrorDescriptor],
                                          [RTResponseDescriptorFactory revokeAccessTokenDescriptor],
                                          [RTResponseDescriptorFactory revokeAccessTokenErrorDescriptor],
                                          [RTResponseDescriptorFactory revokeAccessTokenTokenErrorDescriptor],
                                          [RTResponseDescriptorFactory listReelsDescriptor],
                                          [RTResponseDescriptorFactory listReelsErrorDescriptor],
                                          [RTResponseDescriptorFactory listReelsTokenErrorDescriptor],
                                          [RTResponseDescriptorFactory addReelDescriptor],
                                          [RTResponseDescriptorFactory addReelErrorDescriptor],
                                          [RTResponseDescriptorFactory addReelTokenErrorDescriptor],
                                          [RTResponseDescriptorFactory getReelDescriptor],
                                          [RTResponseDescriptorFactory getReelErrorDescriptor],
                                          [RTResponseDescriptorFactory getReelTokenErrorDescriptor],
                                          [RTResponseDescriptorFactory deleteReelDescriptor],
                                          [RTResponseDescriptorFactory deleteReelErrorDescriptor],
                                          [RTResponseDescriptorFactory deleteReelTokenErrorDescriptor],
                                          [RTResponseDescriptorFactory listAudienceMembersDescriptor],
                                          [RTResponseDescriptorFactory listAudienceMembersErrorDescriptor],
                                          [RTResponseDescriptorFactory listAudienceMembersTokenErrorDescriptor],
                                          [RTResponseDescriptorFactory joinAudienceDescriptor],
                                          [RTResponseDescriptorFactory joinAudienceErrorDescriptor],
                                          [RTResponseDescriptorFactory joinAudienceTokenErrorDescriptor],
                                          [RTResponseDescriptorFactory leaveAudienceDescriptor],
                                          [RTResponseDescriptorFactory leaveAudienceErrorDescriptor],
                                          [RTResponseDescriptorFactory leaveAudienceTokenErrorDescriptor],
                                          [RTResponseDescriptorFactory listReelVideosDescriptor],
                                          [RTResponseDescriptorFactory listReelVideosErrorDescriptor],
                                          [RTResponseDescriptorFactory listReelVideosTokenErrorDescriptor],
                                          [RTResponseDescriptorFactory addVideoToReelDescriptor],
                                          [RTResponseDescriptorFactory addVideoToReelErrorDescriptor],
                                          [RTResponseDescriptorFactory addVideoToReelTokenErrorDescriptor],
                                          [RTResponseDescriptorFactory removeVideoFromReelDescriptor],
                                          [RTResponseDescriptorFactory removeVideoFromReelErrorDescriptor],
                                          [RTResponseDescriptorFactory removeVideoFromReelTokenErrorDescriptor],
                                          [RTResponseDescriptorFactory listUsersDescriptor],
                                          [RTResponseDescriptorFactory listUsersErrorDescriptor],
                                          [RTResponseDescriptorFactory listUsersTokenErrorDescriptor],
                                          [RTResponseDescriptorFactory getUserDescriptor],
                                          [RTResponseDescriptorFactory getUserErrorDescriptor],
                                          [RTResponseDescriptorFactory getUserTokenErrorDescriptor],
                                          [RTResponseDescriptorFactory listUserReelsDescriptor],
                                          [RTResponseDescriptorFactory listUserReelsErrorDescriptor],
                                          [RTResponseDescriptorFactory listUserReelsTokenErrorDescriptor],
                                          [RTResponseDescriptorFactory followUserDescriptor],
                                          [RTResponseDescriptorFactory followUserErrorDescriptor],
                                          [RTResponseDescriptorFactory followUserTokenErrorDescriptor],
                                          [RTResponseDescriptorFactory unfollowUserDescriptor],
                                          [RTResponseDescriptorFactory unfollowUserErrorDescriptor],
                                          [RTResponseDescriptorFactory unfollowUserTokenErrorDescriptor],
                                          [RTResponseDescriptorFactory listFollowersDescriptor],
                                          [RTResponseDescriptorFactory listFollowersErrorDescriptor],
                                          [RTResponseDescriptorFactory listFollowersTokenErrorDescriptor],
                                          [RTResponseDescriptorFactory listFolloweesDescriptor],
                                          [RTResponseDescriptorFactory listFolloweesErrorDescriptor],
                                          [RTResponseDescriptorFactory listFolloweesTokenErrorDescriptor],
                                          [RTResponseDescriptorFactory listVideosDescriptor],
                                          [RTResponseDescriptorFactory listVideosErrorDescriptor],
                                          [RTResponseDescriptorFactory listVideosTokenErrorDescriptor],
                                          [RTResponseDescriptorFactory addVideoDescriptor],
                                          [RTResponseDescriptorFactory addVideoErrorDescriptor],
                                          [RTResponseDescriptorFactory addVideoTokenErrorDescriptor],
                                          [RTResponseDescriptorFactory getVideoDescriptor],
                                          [RTResponseDescriptorFactory getVideoErrorDescriptor],
                                          [RTResponseDescriptorFactory getVideoTokenErrorDescriptor],
                                          [RTResponseDescriptorFactory deleteVideoDescriptor],
                                          [RTResponseDescriptorFactory deleteVideoErrorDescriptor],
                                          [RTResponseDescriptorFactory deleteVideoTokenErrorDescriptor],
                                          [RTResponseDescriptorFactory getThumbnailDescriptor],
                                          [RTResponseDescriptorFactory getThumbnailErrorDescriptor],
                                          [RTResponseDescriptorFactory getThumbnailTokenErrorDescriptor]
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
