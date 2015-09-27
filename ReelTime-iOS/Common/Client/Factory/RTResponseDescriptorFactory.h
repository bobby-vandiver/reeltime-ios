#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface RTResponseDescriptorFactory : NSObject

+ (RKResponseDescriptor *)tokenDescriptor;
+ (RKResponseDescriptor *)tokenErrorDescriptor;

+ (RKResponseDescriptor *)accountRegistrationDescriptor;
+ (RKResponseDescriptor *)accountRegistrationErrorDescriptor;

+ (RKResponseDescriptor *)accountRemovalDescriptor;
+ (RKResponseDescriptor *)accountRemovalErrorDescriptor;
+ (RKResponseDescriptor *)accountRemovalTokenErrorDescriptor;

+ (RKResponseDescriptor *)listClientsDescriptor;
+ (RKResponseDescriptor *)listClientsErrorDescriptor;
+ (RKResponseDescriptor *)listClientsTokenErrorDescriptor;

+ (RKResponseDescriptor *)clientRegistrationDescriptor;
+ (RKResponseDescriptor *)clientRegistrationErrorDescriptor;

+ (RKResponseDescriptor *)clientRemovalDescriptor;
+ (RKResponseDescriptor *)clientRemovalErrorDescriptor;
+ (RKResponseDescriptor *)clientRemovalTokenErrorDescriptor;

+ (RKResponseDescriptor *)accountConfirmationDescriptor;
+ (RKResponseDescriptor *)accountConfirmationErrorDescriptor;
+ (RKResponseDescriptor *)accountConfirmationTokenErrorDescriptor;

+ (RKResponseDescriptor *)accountConfirmationSendEmailDescriptor;
+ (RKResponseDescriptor *)accountConfirmationSendEmailErrorDescriptor;
+ (RKResponseDescriptor *)accountConfirmationSendEmailTokenErrorDescriptor;

+ (RKResponseDescriptor *)changeDisplayNameDescriptor;
+ (RKResponseDescriptor *)changeDisplayNameErrorDescriptor;
+ (RKResponseDescriptor *)changeDisplayNameTokenErrorDescriptor;

+ (RKResponseDescriptor *)changePasswordDescriptor;
+ (RKResponseDescriptor *)changePasswordErrorDescriptor;
+ (RKResponseDescriptor *)changePasswordTokenErrorDescriptor;

+ (RKResponseDescriptor *)resetPasswordForExistingClientDescriptor;
+ (RKResponseDescriptor *)resetPasswordForNewClientDescriptor;
+ (RKResponseDescriptor *)resetPasswordErrorDescriptor;

+ (RKResponseDescriptor *)resetPasswordSendEmailDescriptor;
+ (RKResponseDescriptor *)resetPasswordSendEmailErrorDescriptor;

+ (RKResponseDescriptor *)newsfeedDescriptor;
+ (RKResponseDescriptor *)newsfeedErrorDescriptor;
+ (RKResponseDescriptor *)newsfeedTokenErrorDescriptor;

+ (RKResponseDescriptor *)revokeAccessTokenDescriptor;
+ (RKResponseDescriptor *)revokeAccessTokenErrorDescriptor;
+ (RKResponseDescriptor *)revokeAccessTokenTokenErrorDescriptor;

+ (RKResponseDescriptor *)listReelsDescriptor;
+ (RKResponseDescriptor *)listReelsErrorDescriptor;
+ (RKResponseDescriptor *)listReelsTokenErrorDescriptor;

+ (RKResponseDescriptor *)addReelDescriptor;
+ (RKResponseDescriptor *)addReelErrorDescriptor;
+ (RKResponseDescriptor *)addReelTokenErrorDescriptor;

+ (RKResponseDescriptor *)getReelDescriptor;
+ (RKResponseDescriptor *)getReelErrorDescriptor;
+ (RKResponseDescriptor *)getReelTokenErrorDescriptor;

+ (RKResponseDescriptor *)deleteReelDescriptor;
+ (RKResponseDescriptor *)deleteReelErrorDescriptor;
+ (RKResponseDescriptor *)deleteReelTokenErrorDescriptor;

+ (RKResponseDescriptor *)listReelVideosDescriptor;
+ (RKResponseDescriptor *)listReelVideosErrorDescriptor;
+ (RKResponseDescriptor *)listReelVideosTokenErrorDescriptor;

+ (RKResponseDescriptor *)listAudienceMembersDescriptor;
+ (RKResponseDescriptor *)listAudienceMembersErrorDescriptor;
+ (RKResponseDescriptor *)listAudienceMembersTokenErrorDescriptor;

+ (RKResponseDescriptor *)addVideoToReelDescriptor;
+ (RKResponseDescriptor *)addVideoToReelErrorDescriptor;
+ (RKResponseDescriptor *)addVideoToReelTokenErrorDescriptor;

+ (RKResponseDescriptor *)removeVideoFromReelDescriptor;
+ (RKResponseDescriptor *)removeVideoFromReelErrorDescriptor;
+ (RKResponseDescriptor *)removeVideoFromReelTokenErrorDescriptor;

+ (RKResponseDescriptor *)joinAudienceDescriptor;
+ (RKResponseDescriptor *)joinAudienceErrorDescriptor;
+ (RKResponseDescriptor *)joinAudienceTokenErrorDescriptor;

+ (RKResponseDescriptor *)leaveAudienceDescriptor;
+ (RKResponseDescriptor *)leaveAudienceErrorDescriptor;
+ (RKResponseDescriptor *)leaveAudienceTokenErrorDescriptor;

+ (RKResponseDescriptor *)listUsersDescriptor;
+ (RKResponseDescriptor *)listUsersErrorDescriptor;
+ (RKResponseDescriptor *)listUsersTokenErrorDescriptor;

+ (RKResponseDescriptor *)getUserDescriptor;
+ (RKResponseDescriptor *)getUserErrorDescriptor;
+ (RKResponseDescriptor *)getUserTokenErrorDescriptor;

+ (RKResponseDescriptor *)listUserReelsDescriptor;
+ (RKResponseDescriptor *)listUserReelsErrorDescriptor;
+ (RKResponseDescriptor *)listUserReelsTokenErrorDescriptor;

+ (RKResponseDescriptor *)followUserDescriptor;
+ (RKResponseDescriptor *)followUserErrorDescriptor;
+ (RKResponseDescriptor *)followUserTokenErrorDescriptor;

+ (RKResponseDescriptor *)unfollowUserDescriptor;
+ (RKResponseDescriptor *)unfollowUserErrorDescriptor;
+ (RKResponseDescriptor *)unfollowUserTokenErrorDescriptor;

+ (RKResponseDescriptor *)listFollowersDescriptor;
+ (RKResponseDescriptor *)listFollowersErrorDescriptor;
+ (RKResponseDescriptor *)listFollowersTokenErrorDescriptor;

+ (RKResponseDescriptor *)listFolloweesDescriptor;
+ (RKResponseDescriptor *)listFolloweesErrorDescriptor;
+ (RKResponseDescriptor *)listFolloweesTokenErrorDescriptor;

+ (RKResponseDescriptor *)listVideosDescriptor;
+ (RKResponseDescriptor *)listVideosErrorDescriptor;
+ (RKResponseDescriptor *)listVideosTokenErrorDescriptor;

+ (RKResponseDescriptor *)addVideoDescriptor;
+ (RKResponseDescriptor *)addVideoErrorDescriptor;
+ (RKResponseDescriptor *)addVideoTokenErrorDescriptor;

+ (RKResponseDescriptor *)getVideoDescriptor;
+ (RKResponseDescriptor *)getVideoErrorDescriptor;
+ (RKResponseDescriptor *)getVideoTokenErrorDescriptor;

+ (RKResponseDescriptor *)deleteVideoDescriptor;
+ (RKResponseDescriptor *)deleteVideoErrorDescriptor;
+ (RKResponseDescriptor *)deleteVideoTokenErrorDescriptor;

+ (RKResponseDescriptor *)getThumbnailDescriptor;
+ (RKResponseDescriptor *)getThumbnailErrorDescriptor;
+ (RKResponseDescriptor *)getThumbnailTokenErrorDescriptor;

@end
