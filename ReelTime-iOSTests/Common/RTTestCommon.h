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

// Neither Specta nor Expecta provide a way to unconditionally fail a test
#define fail() expect(0).to.equal(1)

// Constants used in multiple tests
extern NSString *const clientId;
extern NSString *const clientSecret;

extern NSString *const username;
extern NSString *const password;
extern NSString *const email;
extern NSString *const displayName;
extern NSString *const clientName;

extern NSString *const BLANK;

