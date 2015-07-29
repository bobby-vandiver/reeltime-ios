#import <Foundation/Foundation.h>

@class RTUserProfileWireframe;

@interface RTUserProfilePresenter : NSObject

- (instancetype)initWithWireframe:(RTUserProfileWireframe *)wireframe;

- (void)requestedAccountSettings;

- (void)requestedAudienceMembersForReelId:(NSNumber *)reelId;

- (void)requestedFollowersForUsername:(NSString *)username;

- (void)requestedFolloweesForUsername:(NSString *)username;

@end
