#import <Foundation/Foundation.h>

#import "RTAccountRegistrationError.h"
#import "RTAddVideoToReelError.h"
#import "RTConfirmAccountError.h"
#import "RTChangeDisplayNameError.h"
#import "RTChangePasswordError.h"
#import "RTCreateReelError.h"
#import "RTDeleteReelError.h"
#import "RTDeleteVideoError.h"
#import "RTDeviceRegistrationError.h"
#import "RTFollowUserError.h"
#import "RTJoinAudienceError.h"
#import "RTLeaveAudienceError.h"
#import "RTKeyChainError.h"
#import "RTLoginError.h"
#import "RTLogoutError.h"
#import "RTPagedListError.h"
#import "RTPlayVideoError.h"
#import "RTRemoveVideoFromReelError.h"
#import "RTResetPasswordError.h"
#import "RTRevokeClientError.h"
#import "RTUnfollowUserError.h"
#import "RTUserSummaryError.h"

@interface RTErrorFactory : NSObject

+ (NSError *)accountRegistrationErrorWithCode:(RTAccountRegistrationError)code;

+ (NSError *)addVideoToReelErrorWithCode:(RTAddVideoToReelError)code;

+ (NSError *)confirmAccountErrorWithCode:(RTConfirmAccountError)code;

+ (NSError *)changeDisplayNameErrorWithCode:(RTChangeDisplayNameError)code;

+ (NSError *)changePasswordErrorWithCode:(RTChangePasswordError)code;

+ (NSError *)createReelErrorWithCode:(RTCreateReelError)code;

+ (NSError *)deleteReelErrorWithCode:(RTDeleteReelError)code;

+ (NSError *)deleteVideoErrorWithCode:(RTDeleteVideoError)code;

+ (NSError *)deviceRegistrationErrorWithCode:(RTDeviceRegistrationError)code;

+ (NSError *)deviceRegistrationErrorWithCode:(RTDeviceRegistrationError)code
                               originalError:(NSError *)error;

+ (NSError *)followUserErrorWithCode:(RTFollowUserError)code;

+ (NSError *)joinAudienceErrorWithCode:(RTJoinAudienceError)code;

+ (NSError *)leaveAudienceErrorWithCode:(RTLeaveAudienceError)code;

+ (NSError *)keyChainErrorWithCode:(RTKeyChainError)code
                     originalError:(NSError *)error;

+ (NSError *)loginErrorWithCode:(RTLoginError)code;

+ (NSError *)loginErrorWithCode:(RTLoginError)code
                  originalError:(NSError *)error;

+ (NSError *)logoutErrorWithCode:(RTLogoutError)code;

+ (NSError *)logoutErrorWithCode:(RTLogoutError)code
                   originalError:(NSError *)error;

+ (NSError *)pagedListErrorWithCode:(RTPagedListError)code;

+ (NSError *)playVideoErrorWithCode:(RTPlayVideoError)code;

+ (NSError *)removeVideoFromReelErrorWithCode:(RTRemoveVideoFromReelError)code;

+ (NSError *)resetPasswordErrorWithCode:(RTResetPasswordError)code;

+ (NSError *)revokeClientErrorWithCode:(RTRevokeClientError)code;

+ (NSError *)unfollowUserErrorWithCode:(RTUnfollowUserError)code;

+ (NSError *)userSummaryErrorWithCode:(RTUserSummaryError)code;

@end
