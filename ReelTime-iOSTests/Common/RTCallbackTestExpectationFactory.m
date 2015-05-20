#import "RTCallbackTestExpectationFactory.h"
#import "RTCallbackTestExpectation.h"

@implementation RTCallbackTestExpectationFactory

+ (RTCallbackTestExpectation *)noArgsCallback {
    RTCallbackTestExpectation *expectation = [RTCallbackTestExpectation callbackTestExpectation];
    
    __weak RTCallbackTestExpectation *weak = expectation;
    
    expectation.callback = ^(id ignored) {
        [weak wasExecuted];
    };
    
    return expectation;
}

+ (RTCallbackTestExpectation *)userCallback {
    RTCallbackTestExpectation *expectation = [RTCallbackTestExpectation callbackTestExpectation];
    
    __weak RTCallbackTestExpectation *weak = expectation;
    
    expectation.callback = ^(RTUser *user) {
        [weak wasExecuted];
    };
    
    return expectation;
}

@end
