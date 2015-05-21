#import "RTCallbackTestExpectationFactory.h"
#import "RTCallbackTestExpectation.h"

#import "RTTestCommon.h"
#import "RTClientCredentials.h"

@implementation RTCallbackTestExpectationFactory

+ (RTCallbackTestExpectation *)clientCredentialsCallbackForClientId:(NSString *)clientId
                                                       clientSecret:(NSString *)clientSecret {
    RTCallbackTestExpectation *expectation = [RTCallbackTestExpectation callbackTestExpectation];
    
    __weak RTCallbackTestExpectation *weak = expectation;
    
    expectation.callback = ^(RTClientCredentials *credentials) {
        [weak wasExecuted];
        expect(credentials.clientId).to.equal(clientId);
        expect(credentials.clientSecret).to.equal(clientSecret);
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

+ (RTCallbackTestExpectation *)noArgsCallback {
    RTCallbackTestExpectation *expectation = [RTCallbackTestExpectation callbackTestExpectation];
    
    __weak RTCallbackTestExpectation *weak = expectation;
    
    expectation.callback = ^(id ignored) {
        [weak wasExecuted];
    };
    
    return expectation;
}

+ (RTCallbackTestExpectation *)arrayCallback {
    RTCallbackTestExpectation *expectation = [RTCallbackTestExpectation callbackTestExpectation];
    
    __weak RTCallbackTestExpectation *weak = expectation;
    
    expectation.callback = ^(NSArray *items) {
        weak.callbackArguments = items;
        [weak wasExecuted];
    };
    
    return expectation;
}

@end
