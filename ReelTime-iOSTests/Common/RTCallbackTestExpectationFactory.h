#import <Foundation/Foundation.h>
#import "RTCallback.h"

@class RTCallbackTestExpectation;

@interface RTCallbackTestExpectationFactory : NSObject

+ (RTCallbackTestExpectation *)clientCredentialsCallbackForClientId:(NSString *)clientId
                                                       clientSecret:(NSString *)clientSecret;

+ (RTCallbackTestExpectation *)clientListCallback;

+ (RTCallbackTestExpectation *)userCallback;

+ (RTCallbackTestExpectation *)serverErrorsCallback;

+ (RTCallbackTestExpectation *)noArgsCallback;

+ (RTCallbackTestExpectation *)arrayCallback;

@end
