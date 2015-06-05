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

+ (RTCallbackTestExpectation *)clientListCallback {
    return [self createCallback];
}

+ (RTCallbackTestExpectation *)userCallback {
    return [self createCallback];
}

+ (RTCallbackTestExpectation *)serverErrorsCallback {
    return [self createCallback];
}

+ (RTCallbackTestExpectation *)noArgsCallback {
    return [self createCallback];
}

+ (RTCallbackTestExpectation *)arrayCallback {
    return [self createCallback];
}

+ (RTCallbackTestExpectation *)createCallback {
    RTCallbackTestExpectation *expectation = [RTCallbackTestExpectation callbackTestExpectation];
    
    __weak RTCallbackTestExpectation *weak = expectation;
    
    expectation.callback = ^(id args) {
        weak.callbackArguments = args;
        [weak wasExecuted];
    };
    
    return expectation;
}

@end
