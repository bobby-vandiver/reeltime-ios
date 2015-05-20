#import <Foundation/Foundation.h>
#import "RTCallback.h"

@class RTCallbackTestExpectation;

@interface RTCallbackTestExpectationFactory : NSObject

+ (RTCallbackTestExpectation *)noArgsCallback;

+ (RTCallbackTestExpectation *)userCallback;

@end
