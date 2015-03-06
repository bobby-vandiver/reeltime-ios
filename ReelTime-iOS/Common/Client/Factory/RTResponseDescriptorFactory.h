#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface RTResponseDescriptorFactory : NSObject

+ (RKResponseDescriptor *)tokenDescriptor;
+ (RKResponseDescriptor *)tokenErrorDescriptor;

+ (RKResponseDescriptor *)accountRegistrationDescriptor;
+ (RKResponseDescriptor *)accountRegistrationErrorDescriptor;

+ (RKResponseDescriptor *)accountRemovalDescriptor;
+ (RKResponseDescriptor *)accountRemovalErrorDescriptor;

+ (RKResponseDescriptor *)clientRegistrationDescriptor;
+ (RKResponseDescriptor *)clientRegistrationErrorDescriptor;

+ (RKResponseDescriptor *)clientRemovalDescriptor;
+ (RKResponseDescriptor *)clientRemovalErrorDescriptor;

+ (RKResponseDescriptor *)accountConfirmationDescriptor;
+ (RKResponseDescriptor *)accountConfirmationErrorDescriptor;

+ (RKResponseDescriptor *)accountConfirmationSendEmailDescriptor;
+ (RKResponseDescriptor *)accountConfirmationSendEmailErrorDescriptor;

+ (RKResponseDescriptor *)changeDisplayNameDescriptor;
+ (RKResponseDescriptor *)changeDisplayNameErrorDescriptor;

+ (RKResponseDescriptor *)changePasswordDescriptor;
+ (RKResponseDescriptor *)changePasswordErrorDescriptor;

+ (RKResponseDescriptor *)resetPasswordForExistingClientDescriptor;
+ (RKResponseDescriptor *)resetPasswordForNewClientDescriptor;
+ (RKResponseDescriptor *)resetPasswordErrorDescriptor;

+ (RKResponseDescriptor *)resetPasswordSendEmailDescriptor;
+ (RKResponseDescriptor *)resetPasswordSendEmailErrorDescriptor;

+ (RKResponseDescriptor *)newsfeedDescriptor;
+ (RKResponseDescriptor *)newsfeedErrorDescriptor;

+ (RKResponseDescriptor *)listReelsDescriptor;
+ (RKResponseDescriptor *)listReelsErrorDescriptor;

+ (RKResponseDescriptor *)addReelDescriptor;
+ (RKResponseDescriptor *)addReelErrorDescriptor;

+ (RKResponseDescriptor *)getReelDescriptor;
+ (RKResponseDescriptor *)getReelErrorDescriptor;

+ (RKResponseDescriptor *)deleteReelDescriptor;
+ (RKResponseDescriptor *)deleteReelErrorDescriptor;

+ (RKResponseDescriptor *)listReelVideosDescriptor;
+ (RKResponseDescriptor *)listReelVideosErrorDescriptor;

+ (RKResponseDescriptor *)listAudienceMembersDescriptor;
+ (RKResponseDescriptor *)listAudienceMembersErrorDescriptor;

+ (RKResponseDescriptor *)addVideoToReelDescriptor;
+ (RKResponseDescriptor *)addVideoToReelErrorDescriptor;

+ (RKResponseDescriptor *)removeVideoFromReelDescriptor;
+ (RKResponseDescriptor *)removeVideoFromReelErrorDescriptor;

+ (RKResponseDescriptor *)joinAudienceDescriptor;
+ (RKResponseDescriptor *)joinAudienceErrorDescriptor;

+ (RKResponseDescriptor *)leaveAudienceDescriptor;
+ (RKResponseDescriptor *)leaveAudienceErrorDescriptor;

+ (RKResponseDescriptor *)listUsersDescriptor;
+ (RKResponseDescriptor *)listUsersErrorDescriptor;

+ (RKResponseDescriptor *)getUserDescriptor;
+ (RKResponseDescriptor *)getUserErrorDescriptor;

+ (RKResponseDescriptor *)listUserReelsDescriptor;
+ (RKResponseDescriptor *)listUserReelsErrorDescriptor;

+ (RKResponseDescriptor *)followUserDescriptor;
+ (RKResponseDescriptor *)followUserErrorDescriptor;

+ (RKResponseDescriptor *)unfollowUserDescriptor;
+ (RKResponseDescriptor *)unfollowUserErrorDescriptor;

+ (RKResponseDescriptor *)listFollowersDescriptor;
+ (RKResponseDescriptor *)listFollowersErrorDescriptor;

+ (RKResponseDescriptor *)listFolloweesDescriptor;
+ (RKResponseDescriptor *)listFolloweesErrorDescriptor;

+ (RKResponseDescriptor *)listVideosDescriptor;
+ (RKResponseDescriptor *)listVideosErrorDescriptor;

@end
