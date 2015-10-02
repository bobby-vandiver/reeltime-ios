#import <Foundation/Foundation.h>
#import "RTCallbacks.h"

@interface RTOAuth2TokenRenegotiationStatus : NSObject

@property (readonly) BOOL renegotiationInProgress;

@property (readonly) BOOL lastRenegotiationSucceeded;

- (void)renegotiationStarted;

- (void)renegotiationFinished:(BOOL)success;

- (void)waitUntilRenegotiationIsFinished:(NoArgsCallback)callback;

@end
