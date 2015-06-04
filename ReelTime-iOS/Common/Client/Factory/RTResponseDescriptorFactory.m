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
    return [self serverErrorsDescriptorForMethod:RKRequestMethodDELETE
                                            path:API_REMOVE_ACCOUNT
                                      statusCode:403];
}

+ (RKResponseDescriptor *)listClientsDescriptor {
    return [RKResponseDescriptor responseDescriptorWithMapping:[RTRestAPIMappingFactory clientListMapping]
                                                        method:RKRequestMethodGET
                                                   pathPattern:API_LIST_CLIENTS
                                                    statusCode:200];
}

+ (RKResponseDescriptor *)listClientsErrorDescriptor {
    return [self serverErrorsDescriptorForMethod:RKRequestMethodGET
                                            path:API_LIST_CLIENTS
                                      statusCode:400];
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
    return [self serverErrorsDescriptorForMethod:RKRequestMethodDELETE
                                            path:API_REMOVE_CLIENT
                                      statusCode:403];
}

+ (RKResponseDescriptor *)accountConfirmationDescriptor {
    return [self noResponseBodyDescriptorForMethod:RKRequestMethodPOST
                                              path:API_CONFIRM_ACCOUNT
                                        statusCode:200];
}

+ (RKResponseDescriptor *)accountConfirmationErrorDescriptor {
    return [self serverErrorsDescriptorForMethod:RKRequestMethodPOST
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
    NSMutableIndexSet *statusCodes = [NSMutableIndexSet indexSet];
    
    [statusCodes addIndex:404];
    [statusCodes addIndex:503];

    return [self serverErrorsDescriptorForMethod:RKRequestMethodPOST
                                            path:API_RESET_PASSWORD_SEND_EMAIL
                                     statusCodes:statusCodes];
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

+ (RKResponseDescriptor *)revokeAccessTokenDescriptor {
    return [self noResponseBodyDescriptorForMethod:RKRequestMethodDELETE
                                              path:API_REMOVE_TOKEN
                                        statusCode:200];
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
    NSIndexSet *statusCodes = [self forbiddenAndNotFoundStatusCodes];
    return [self serverErrorsDescriptorForMethod:RKRequestMethodDELETE
                                            path:API_DELETE_REEL
                                     statusCodes:statusCodes];
}

+ (RKResponseDescriptor *)listReelVideosDescriptor {
    return [RKResponseDescriptor responseDescriptorWithMapping:[RTRestAPIMappingFactory videoListMapping]
                                                        method:RKRequestMethodGET
                                                   pathPattern:API_LIST_REEL_VIDEOS
                                                    statusCode:200];
}

+ (RKResponseDescriptor *)listReelVideosErrorDescriptor {
    NSIndexSet *statusCodes = [self badRequestAndNotFoundStatusCodes];
    return [self serverErrorsDescriptorForMethod:RKRequestMethodGET
                                            path:API_LIST_REEL_VIDEOS
                                     statusCodes:statusCodes];
}

+ (RKResponseDescriptor *)listAudienceMembersDescriptor {
    return [RKResponseDescriptor responseDescriptorWithMapping:[RTRestAPIMappingFactory userListMapping]
                                                        method:RKRequestMethodGET
                                                   pathPattern:API_LIST_AUDIENCE_MEMBERS
                                                    statusCode:200];
}

+ (RKResponseDescriptor *)listAudienceMembersErrorDescriptor {
    NSIndexSet *statusCodes = [self badRequestAndNotFoundStatusCodes];
    return [self serverErrorsDescriptorForMethod:RKRequestMethodGET
                                            path:API_LIST_AUDIENCE_MEMBERS
                                     statusCodes:statusCodes];
}

+ (RKResponseDescriptor *)addVideoToReelDescriptor {
    return [self noResponseBodyDescriptorForMethod:RKRequestMethodPOST
                                              path:API_ADD_REEL_VIDEO
                                        statusCode:201];
}

+ (RKResponseDescriptor *)addVideoToReelErrorDescriptor {
    NSIndexSet *statusCodes = [self forbiddenAndNotFoundStatusCodes];
    return [self serverErrorsDescriptorForMethod:RKRequestMethodPOST
                                            path:API_ADD_REEL_VIDEO
                                     statusCodes:statusCodes];
}

+ (RKResponseDescriptor *)removeVideoFromReelDescriptor {
    return [self noResponseBodyDescriptorForMethod:RKRequestMethodDELETE
                                              path:API_REMOVE_REEL_VIDEO
                                        statusCode:200];
}

+ (RKResponseDescriptor *)removeVideoFromReelErrorDescriptor {
    NSIndexSet *statusCodes = [self forbiddenAndNotFoundStatusCodes];
    return [self serverErrorsDescriptorForMethod:RKRequestMethodDELETE
                                            path:API_REMOVE_REEL_VIDEO
                                     statusCodes:statusCodes];
}

+ (RKResponseDescriptor *)joinAudienceDescriptor {
    return [self noResponseBodyDescriptorForMethod:RKRequestMethodPOST
                                              path:API_ADD_AUDIENCE_MEMBER
                                        statusCode:200];
}

+ (RKResponseDescriptor *)joinAudienceErrorDescriptor {
    NSIndexSet *statusCodes = [self forbiddenAndNotFoundStatusCodes];
    return [self serverErrorsDescriptorForMethod:RKRequestMethodPOST
                                            path:API_ADD_AUDIENCE_MEMBER
                                     statusCodes:statusCodes];
}

+ (RKResponseDescriptor *)leaveAudienceDescriptor {
    return [self noResponseBodyDescriptorForMethod:RKRequestMethodDELETE
                                              path:API_REMOVE_AUDIENCE_MEMBER
                                        statusCode:200];
}

+ (RKResponseDescriptor *)leaveAudienceErrorDescriptor {
    NSIndexSet *statusCodes = [self forbiddenAndNotFoundStatusCodes];
    return [self serverErrorsDescriptorForMethod:RKRequestMethodDELETE
                                            path:API_REMOVE_AUDIENCE_MEMBER
                                     statusCodes:statusCodes];
}

+ (RKResponseDescriptor *)listUsersDescriptor {
    return [RKResponseDescriptor responseDescriptorWithMapping:[RTRestAPIMappingFactory userListMapping]
                                                        method:RKRequestMethodGET
                                                   pathPattern:API_LIST_USERS
                                                    statusCode:200];
}

+ (RKResponseDescriptor *)listUsersErrorDescriptor {
    return [self serverErrorsDescriptorForMethod:RKRequestMethodGET
                                            path:API_LIST_USERS
                                      statusCode:400];
}

+ (RKResponseDescriptor *)getUserDescriptor {
    return [RKResponseDescriptor responseDescriptorWithMapping:[RTRestAPIMappingFactory userMapping]
                                                        method:RKRequestMethodGET
                                                   pathPattern:API_GET_USER
                                                    statusCode:200];
}

+ (RKResponseDescriptor *)getUserErrorDescriptor {
    return [self serverErrorsDescriptorForMethod:RKRequestMethodGET
                                            path:API_GET_USER
                                      statusCode:404];
}

+ (RKResponseDescriptor *)listUserReelsDescriptor {
    return [RKResponseDescriptor responseDescriptorWithMapping:[RTRestAPIMappingFactory reelListMapping]
                                                        method:RKRequestMethodGET
                                                   pathPattern:API_LIST_USER_REELS
                                                    statusCode:200];
}

+ (RKResponseDescriptor *)listUserReelsErrorDescriptor {
    NSIndexSet *statusCodes = [self badRequestAndNotFoundStatusCodes];
    return [self serverErrorsDescriptorForMethod:RKRequestMethodGET
                                            path:API_LIST_USER_REELS
                                     statusCodes:statusCodes];
}

+ (RKResponseDescriptor *)followUserDescriptor {
    return [self noResponseBodyDescriptorForMethod:RKRequestMethodPOST
                                              path:API_FOLLOW_USER
                                        statusCode:200];
}

+ (RKResponseDescriptor *)followUserErrorDescriptor {
    NSIndexSet *statusCodes = [self forbiddenAndNotFoundStatusCodes];
    return [self serverErrorsDescriptorForMethod:RKRequestMethodPOST
                                            path:API_FOLLOW_USER
                                     statusCodes:statusCodes];
}

+ (RKResponseDescriptor *)unfollowUserDescriptor {
    return [self noResponseBodyDescriptorForMethod:RKRequestMethodDELETE
                                              path:API_UNFOLLOW_USER
                                        statusCode:200];
}

+ (RKResponseDescriptor *)unfollowUserErrorDescriptor {
    NSIndexSet *statusCodes = [self forbiddenAndNotFoundStatusCodes];
    return [self serverErrorsDescriptorForMethod:RKRequestMethodDELETE
                                            path:API_UNFOLLOW_USER
                                     statusCodes:statusCodes];
}

+ (RKResponseDescriptor *)listFollowersDescriptor {
    return [RKResponseDescriptor responseDescriptorWithMapping:[RTRestAPIMappingFactory userListMapping]
                                                        method:RKRequestMethodGET
                                                   pathPattern:API_LIST_FOLLOWERS
                                                    statusCode:200];
}

+ (RKResponseDescriptor *)listFollowersErrorDescriptor {
    return [self serverErrorsDescriptorForMethod:RKRequestMethodGET
                                            path:API_LIST_FOLLOWERS
                                      statusCode:400];
}

+ (RKResponseDescriptor *)listFolloweesDescriptor {
    return [RKResponseDescriptor responseDescriptorWithMapping:[RTRestAPIMappingFactory userListMapping]
                                                        method:RKRequestMethodGET
                                                   pathPattern:API_LIST_FOLLOWEES
                                                    statusCode:200];
}

+ (RKResponseDescriptor *)listFolloweesErrorDescriptor {
    return [self serverErrorsDescriptorForMethod:RKRequestMethodGET
                                            path:API_LIST_FOLLOWEES
                                      statusCode:400];
}

+ (RKResponseDescriptor *)listVideosDescriptor {
    return [RKResponseDescriptor responseDescriptorWithMapping:[RTRestAPIMappingFactory videoListMapping]
                                                        method:RKRequestMethodGET
                                                   pathPattern:API_LIST_VIDEOS
                                                    statusCode:200];
}

+ (RKResponseDescriptor *)listVideosErrorDescriptor {
    return [self serverErrorsDescriptorForMethod:RKRequestMethodGET
                                            path:API_LIST_VIDEOS
                                     statusCode:400];
}

+ (RKResponseDescriptor *)addVideoDescriptor {
    return [RKResponseDescriptor responseDescriptorWithMapping:[RTRestAPIMappingFactory videoMapping]
                                                        method:RKRequestMethodPOST
                                                   pathPattern:API_ADD_VIDEO
                                                    statusCode:202];
}

+ (RKResponseDescriptor *)addVideoErrorDescriptor {
    NSMutableIndexSet *statusCodes = [NSMutableIndexSet indexSet];
    
    [statusCodes addIndex:400];
    [statusCodes addIndex:403];
    [statusCodes addIndex:503];
    
    return [self serverErrorsDescriptorForMethod:RKRequestMethodPOST
                                            path:API_ADD_VIDEO
                                     statusCodes:statusCodes];
}

+ (RKResponseDescriptor *)getVideoDescriptor {
    NSMutableIndexSet *statusCodes = [NSMutableIndexSet indexSet];
    
    [statusCodes addIndex:200];
    [statusCodes addIndex:202];
    
    return [RKResponseDescriptor responseDescriptorWithMapping:[RTRestAPIMappingFactory videoMapping]
                                                        method:RKRequestMethodGET
                                                   pathPattern:API_GET_VIDEO
                                                   statusCodes:statusCodes];
}

+ (RKResponseDescriptor *)getVideoErrorDescriptor {
    return [self serverErrorsDescriptorForMethod:RKRequestMethodGET
                                            path:API_GET_VIDEO
                                      statusCode:404];
}

+ (RKResponseDescriptor *)deleteVideoDescriptor {
    return [self noResponseBodyDescriptorForMethod:RKRequestMethodDELETE
                                              path:API_DELETE_VIDEO
                                        statusCode:200];
}

+ (RKResponseDescriptor *)deleteVideoErrorDescriptor {
    return [self serverErrorsDescriptorForMethod:RKRequestMethodDELETE
                                            path:API_DELETE_VIDEO
                                      statusCode:404];
}

+ (RKResponseDescriptor *)getThumbnailDescriptor {
    return [self noResponseBodyDescriptorForMethod:RKRequestMethodGET
                                              path:API_GET_VIDEO_THUMBNAIL
                                        statusCode:200];
}

+ (NSIndexSet *)forbiddenAndNotFoundStatusCodes {
    NSMutableIndexSet *statusCodes = [NSMutableIndexSet indexSet];

    [statusCodes addIndex:403];
    [statusCodes addIndex:404];
    
    return statusCodes;
}

+ (NSIndexSet *)badRequestAndNotFoundStatusCodes {
    NSMutableIndexSet *statusCodes = [NSMutableIndexSet indexSet];

    [statusCodes addIndex:400];
    [statusCodes addIndex:404];
    
    return statusCodes;
}

+ (NSIndexSet *)badRequestAndServiceUnavailableStatusCodes {
    NSMutableIndexSet *statusCodes = [NSMutableIndexSet indexSet];
    
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
