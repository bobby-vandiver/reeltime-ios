#import "RTTestCommon.h"

NSString *const clientId = @"foo";
NSString *const clientSecret = @"bar";

NSString *const username = @"someone";
NSString *const password = @"secret";
NSString *const confirmationPassword = @"different";
NSString *const email = @"someone@test.com";
NSString *const displayName = @"Some One";
NSString *const clientName = @"iPhone";

NSString *const BLANK = @"";

const NSUInteger reelId = 49132;
const NSUInteger videoId = 841;
const NSUInteger pageNumber = 13;

NSString *const confirmationCode = @"confirm";
NSString *const resetCode = @"reset";

NSString *const accessToken = @"access";
NSString *const refreshToken = @"refresh";

NSNull *null() {
    return [NSNull null];
}

NSString *getParameterOrDefault(NSString *parameter, NSString *defaultValue) {
    NSString *value;
    
    if (parameter) {
        value = [parameter isEqual:null()] ? nil : parameter;
    }
    else {
        value = defaultValue;
    }
    
    return value;
}
