#import "RTResponseDescriptorFactory.h"
#import "RTRestAPIMappingFactory.h"
#import "RTRestAPI.h"
#import "RKResponseDescriptor+SingleStatusCode.h"

@implementation RTResponseDescriptorFactory

+ (RKResponseDescriptor *)tokenDescriptor {
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    
    return [RKResponseDescriptor responseDescriptorWithMapping:[RTRestAPIMappingFactory tokenMapping]
                                                        method:RKRequestMethodPOST
                                                   pathPattern:API_TOKEN
                                                   statusCodes:statusCodes];
}

+ (RKResponseDescriptor *)tokenErrorDescriptor {
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassClientError);
    
    return [RKResponseDescriptor responseDescriptorWithMapping:[RTRestAPIMappingFactory tokenErrorMapping]
                                                        method:RKRequestMethodPOST
                                                   pathPattern:API_TOKEN
                                                   statusCodes:statusCodes];
}

+ (RKResponseDescriptor *)accountRegistrationDescriptor {
    return [RKResponseDescriptor responseDescriptorWithMapping:[RTRestAPIMappingFactory clientCredentialsMapping]
                                                        method:RKRequestMethodPOST
                                                   pathPattern:API_REGISTER_ACCOUNT
                                                    statusCode:201];
}

+ (RKResponseDescriptor *)accountRegistrationErrorDescriptor {
    NSIndexSet *statusCodes = [self badRequestAndServiceUnavailableStatusCodes];
    
    return [self serverErrorsDescriptorForMethod:RKRequestMethodPOST
                                            path:API_REGISTER_ACCOUNT
                                     statusCodes:statusCodes];
}

+ (RKResponseDescriptor *)accountRemovalDescriptor {
    return [self noResponseBodyDescriptorForMethod:RKRequestMethodDELETE
                                              path:API_REMOVE_ACCOUNT
                                        statusCode:200];
}

+ (RKResponseDescriptor *)accountRemovalErrorDescriptor {
    return [self noResponseBodyDescriptorForMethod:RKRequestMethodDELETE
                                              path:API_REMOVE_ACCOUNT
                                        statusCode:403];
}

+ (RKResponseDescriptor *)clientRegistrationDescriptor {
    return [RKResponseDescriptor responseDescriptorWithMapping:[RTRestAPIMappingFactory clientCredentialsMapping]
                                                        method:RKRequestMethodPOST
                                                   pathPattern:API_REGISTER_CLIENT
                                                    statusCode:201];
}

+ (RKResponseDescriptor *)clientRegistrationErrorDescriptor {
    NSIndexSet *statusCodes = [self badRequestAndServiceUnavailableStatusCodes];
    
    return [self serverErrorsDescriptorForMethod:RKRequestMethodPOST
                                            path:API_REGISTER_CLIENT
                                     statusCodes:statusCodes];
}

+ (RKResponseDescriptor *)clientRemovalDescriptor {
    return [self noResponseBodyDescriptorForMethod:RKRequestMethodDELETE
                                              path:API_REMOVE_CLIENT
                                        statusCode:200];
}

+ (RKResponseDescriptor *)clientRemovalErrorDescriptor {
    return [self noResponseBodyDescriptorForMethod:RKRequestMethodDELETE
                                              path:API_REMOVE_CLIENT
                                        statusCode:403];
}

+ (RKResponseDescriptor *)accountConfirmationDescriptor {
    return [self noResponseBodyDescriptorForMethod:RKRequestMethodPOST
                                              path:API_CONFIRM_ACCOUNT
                                        statusCode:200];
}

+ (RKResponseDescriptor *)accountConfirmationErrorDescriptor {
    return [self noResponseBodyDescriptorForMethod:RKRequestMethodPOST
                                              path:API_CONFIRM_ACCOUNT
                                        statusCode:403];
}

+ (RKResponseDescriptor *)accountConfirmationSendEmailDescriptor {
    return [self noResponseBodyDescriptorForMethod:RKRequestMethodPOST
                                              path:API_CONFIRM_ACCOUNT_SEND_EMAIL
                                        statusCode:200];
}

+ (RKResponseDescriptor *)accountConfirmationSendEmailErrorDescriptor {
    NSIndexSet *statusCodes = [NSIndexSet indexSetWithIndex:503];
    
    return [self serverErrorsDescriptorForMethod:RKRequestMethodPOST
                                            path:API_CONFIRM_ACCOUNT_SEND_EMAIL
                                     statusCodes:statusCodes];
}

+ (RKResponseDescriptor *)changeDisplayNameDescriptor {
    return [self noResponseBodyDescriptorForMethod:RKRequestMethodPOST
                                              path:API_CHANGE_DISPLAY_NAME
                                        statusCode:200];
}

+ (RKResponseDescriptor *)changeDisplayNameErrorDescriptor {
    return [self serverErrorsDescriptorForMethod:RKRequestMethodPOST
                                            path:API_CHANGE_DISPLAY_NAME
                                      statusCode:400];
}

+ (RKResponseDescriptor *)changePasswordDescriptor {
    return [self noResponseBodyDescriptorForMethod:RKRequestMethodPOST
                                              path:API_CHANGE_PASSWORD
                                        statusCode:200];
}

+ (RKResponseDescriptor *)changePasswordErrorDescriptor {
    return [self serverErrorsDescriptorForMethod:RKRequestMethodPOST
                                            path:API_CHANGE_PASSWORD
                                      statusCode:400];
}

+ (RKResponseDescriptor *)resetPasswordForExistingClientDescriptor {
    return [self noResponseBodyDescriptorForMethod:RKRequestMethodPOST
                                              path:API_RESET_PASSWORD
                                        statusCode:200];
}

+ (RKResponseDescriptor *)resetPasswordForNewClientDescriptor {
    return [RKResponseDescriptor responseDescriptorWithMapping:[RTRestAPIMappingFactory clientCredentialsMapping]
                                                        method:RKRequestMethodPOST
                                                   pathPattern:API_RESET_PASSWORD
                                                    statusCode:201];
}

+ (RKResponseDescriptor *)resetPasswordErrorDescriptor {
    NSIndexSet *statusCodes = [self badRequestAndServiceUnavailableStatusCodes];
    
    return [self serverErrorsDescriptorForMethod:RKRequestMethodPOST
                                            path:API_RESET_PASSWORD
                                      statusCodes:statusCodes];
}

+ (RKResponseDescriptor *)resetPasswordSendEmailDescriptor {
    return [self noResponseBodyDescriptorForMethod:RKRequestMethodPOST
                                              path:API_RESET_PASSWORD_SEND_EMAIL
                                        statusCode:200];
}

+ (RKResponseDescriptor *)resetPasswordSendEmailErrorDescriptor {
    return [self serverErrorsDescriptorForMethod:RKRequestMethodPOST
                                            path:API_RESET_PASSWORD_SEND_EMAIL
                                      statusCode:503];
}

+ (RKResponseDescriptor *)newsfeedDescriptor {
    return [RKResponseDescriptor responseDescriptorWithMapping:[RTRestAPIMappingFactory newsfeedMapping]
                                                        method:RKRequestMethodGET
                                                   pathPattern:API_NEWSFEED
                                                    statusCode:200];
}

+ (RKResponseDescriptor *)newsfeedErrorDescriptor {
    return [self serverErrorsDescriptorForMethod:RKRequestMethodGET
                                            path:API_NEWSFEED
                                      statusCode:400];
}

+ (RKResponseDescriptor *)listReelsDescriptor {
    return [RKResponseDescriptor responseDescriptorWithMapping:[RTRestAPIMappingFactory reelListMapping]
                                                        method:RKRequestMethodGET
                                                   pathPattern:API_LIST_REELS
                                                    statusCode:200];
}

+ (RKResponseDescriptor *)listReelsErrorDescriptor {
    return [self serverErrorsDescriptorForMethod:RKRequestMethodGET
                                            path:API_LIST_REELS
                                      statusCode:400];
}

+ (RKResponseDescriptor *)addReelDescriptor {
    return [RKResponseDescriptor responseDescriptorWithMapping:[RTRestAPIMappingFactory reelMapping]
                                                        method:RKRequestMethodPOST
                                                   pathPattern:API_ADD_REEL
                                                    statusCode:201];
}

+ (RKResponseDescriptor *)addReelErrorDescriptor {
    return [self serverErrorsDescriptorForMethod:RKRequestMethodPOST
                                            path:API_ADD_REEL
                                      statusCode:400];
}

+ (RKResponseDescriptor *)getReelDescriptor {
    return [RKResponseDescriptor responseDescriptorWithMapping:[RTRestAPIMappingFactory reelMapping]
                                                        method:RKRequestMethodGET
                                                   pathPattern:API_GET_REEL
                                                    statusCode:200];
}

+ (RKResponseDescriptor *)getReelErrorDescriptor {
    return [self serverErrorsDescriptorForMethod:RKRequestMethodGET
                                            path:API_GET_REEL
                                      statusCode:404];
}

+ (RKResponseDescriptor *)deleteReelDescriptor {
    return [self noResponseBodyDescriptorForMethod:RKRequestMethodDELETE
                                              path:API_DELETE_REEL
                                        statusCode:200];
}

+ (RKResponseDescriptor *)deleteReelErrorDescriptor {
    return [self serverErrorsDescriptorForMethod:RKRequestMethodDELETE
                                            path:API_DELETE_REEL
                                      statusCode:404];
}

+ (RKResponseDescriptor *)listAudienceMembersDescriptor {
    return [RKResponseDescriptor responseDescriptorWithMapping:[RTRestAPIMappingFactory userListMapping]
                                                        method:RKRequestMethodGET
                                                   pathPattern:API_LIST_AUDIENCE_MEMBERS
                                                    statusCode:200];
}

+ (RKResponseDescriptor *)listAudienceMembersErrorDescriptor {
    NSMutableIndexSet *statusCodes = [NSMutableIndexSet indexSet];
    [statusCodes addIndex:400];
    [statusCodes addIndex:404];
    
    return [self serverErrorsDescriptorForMethod:RKRequestMethodGET
                                            path:API_LIST_AUDIENCE_MEMBERS
                                     statusCodes:statusCodes];
}

+ (RKResponseDescriptor *)joinAudienceDescriptor {
    return [self noResponseBodyDescriptorForMethod:RKRequestMethodPOST
                                              path:API_ADD_AUDIENCE_MEMBER
                                        statusCode:200];
}

+ (RKResponseDescriptor *)joinAudienceErrorDescriptor {
    return [self serverErrorsDescriptorForMethod:RKRequestMethodPOST
                                            path:API_ADD_AUDIENCE_MEMBER
                                      statusCode:404];
}

+ (RKResponseDescriptor *)leaveAudienceDescriptor {
    return [self noResponseBodyDescriptorForMethod:RKRequestMethodDELETE
                                              path:API_REMOVE_AUDIENCE_MEMBER
                                        statusCode:200];
}

+ (RKResponseDescriptor *)leaveAudienceErrorDescriptor {
    return [self serverErrorsDescriptorForMethod:RKRequestMethodDELETE
                                            path:API_REMOVE_AUDIENCE_MEMBER
                                      statusCode:404];
}

+ (RKResponseDescriptor *)followUserDescriptor {
    return [self noResponseBodyDescriptorForMethod:RKRequestMethodPOST
                                              path:API_FOLLOW_USER
                                        statusCode:200];
}

+ (RKResponseDescriptor *)followUserErrorDescriptor {
    return [self serverErrorsDescriptorForMethod:RKRequestMethodPOST
                                            path:API_FOLLOW_USER
                                      statusCode:400];
}

+ (RKResponseDescriptor *)unfollowUserDescriptor {
    return [self noResponseBodyDescriptorForMethod:RKRequestMethodDELETE
                                              path:API_UNFOLLOW_USER
                                        statusCode:200];
}

+ (RKResponseDescriptor *)unfollowUserErrorDescriptor {
    return [self serverErrorsDescriptorForMethod:RKRequestMethodDELETE
                                            path:API_UNFOLLOW_USER
                                      statusCode:400];
}

+ (NSIndexSet *)badRequestAndServiceUnavailableStatusCodes {
    NSMutableIndexSet *statusCodes = [[NSMutableIndexSet alloc] init];
    
    [statusCodes addIndex:400];
    [statusCodes addIndex:503];

    return statusCodes;
}

+ (RKResponseDescriptor *)serverErrorsDescriptorForMethod:(RKRequestMethod)method
                                                     path:(NSString *)path
                                               statusCode:(NSUInteger)statusCode {
    NSIndexSet *statusCodes = [NSIndexSet indexSetWithIndex:statusCode];
    return [self serverErrorsDescriptorForMethod:method
                                            path:path
                                     statusCodes:statusCodes];
}

+ (RKResponseDescriptor *)serverErrorsDescriptorForMethod:(RKRequestMethod)method
                                                     path:(NSString *)path
                                              statusCodes:(NSIndexSet *)statusCodes {
    return [RKResponseDescriptor responseDescriptorWithMapping:[RTRestAPIMappingFactory serverErrorsMapping]
                                                        method:method
                                                   pathPattern:path
                                                   statusCodes:statusCodes];
}

+ (RKResponseDescriptor *)noResponseBodyDescriptorForMethod:(RKRequestMethod)method
                                                       path:(NSString *)path
                                                 statusCode:(NSUInteger)statusCode {
    NSIndexSet *statusCodes = [NSIndexSet indexSetWithIndex:statusCode];
    return [self noResponseBodyDescriptorForMethod:method
                                              path:path
                                       statusCodes:statusCodes];
}

+ (RKResponseDescriptor *)noResponseBodyDescriptorForMethod:(RKRequestMethod)method
                                                       path:(NSString *)path
                                                statusCodes:(NSIndexSet *)statusCodes {
    return [RKResponseDescriptor responseDescriptorWithMapping:[RTRestAPIMappingFactory emptyMapping]
                                                        method:method
                                                   pathPattern:path
                                                   statusCodes:statusCodes];
}

@end
