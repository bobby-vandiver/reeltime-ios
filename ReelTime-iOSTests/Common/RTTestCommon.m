#import "RTTestCommon.h"

NSString *const clientId = @"foo";
NSString *const clientSecret = @"bar";

NSString *const username = @"someone";
NSString *const password = @"secret";
NSString *const email = @"someone@test.com";
NSString *const displayName = @"Some One";
NSString *const clientName = @"iPhone";

NSString *const BLANK = @"";

const NSUInteger reelId = 49132;
const NSUInteger videoId = 841;
const NSUInteger pageNumber = 13;

NSString *const resetCode = @"reset";

NSString *getParameterOrDefault(NSString *parameter, NSString *defaultValue) {
    NSString *value;
    
    if (parameter) {
        value = [parameter isEqual:[NSNull null]] ? nil : parameter;
    }
    else {
        value = defaultValue;
    }
    
    return value;
}