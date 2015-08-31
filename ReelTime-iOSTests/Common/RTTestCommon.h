#define EXP_SHORTHAND
#define MOCKITO_SHORTHAND
#define HC_SHORTHAND

#import <Specta/Specta.h>
#import <Expecta/Expecta.h>

#import <OCMockito/OCMockito.h>
#import <OCHamcrest/OCHamcrest.h>

#import "EXPMatchers+beError.h"
#import "NSError+RTError.h"

#import "EXPMatchers+beUser.h"
#import "EXPMatchers+beReel.h"
#import "EXPMatchers+beVideo.h"

#import "RTValidationTestHelper.h"

#import "RTErrorPresentationChecker.h"
#import "RTFieldErrorPresentationChecker.h"

#import "RTCallbackTestExpectation.h"
#import "RTLogging.h"

// Constants used in multiple tests
extern NSString *const clientId;
extern NSString *const clientSecret;

extern NSString *const username;
extern NSString *const password;
extern NSString *const confirmationPassword;
extern NSString *const email;
extern NSString *const displayName;
extern NSString *const clientName;

extern NSString *const BLANK;

extern NSString *const reelName;

extern const NSUInteger reelId;
extern const NSUInteger videoId;
extern const NSUInteger pageNumber;

extern NSString *const confirmationCode;
extern NSString *const resetCode;

extern NSString *const accessToken;
extern NSString *const refreshToken;

extern NSNull *null();
extern NSString *getParameterOrDefault(NSString *parameter, NSString *defaultValue);
