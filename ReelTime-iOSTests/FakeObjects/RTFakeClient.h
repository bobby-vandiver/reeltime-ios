#import "RTClient.h"
#import "RTClientErrors.h"

@interface RTFakeClient : RTClient

@property BOOL tokenShouldSucceed;

@property RTOAuth2Token *token;
@property RTClientTokenErrors tokenErrorCode;

@end
