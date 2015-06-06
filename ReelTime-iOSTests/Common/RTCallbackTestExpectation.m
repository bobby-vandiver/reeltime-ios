#import "RTCallbackTestExpectation.h"
#import "RTTestCommon.h"

@interface RTCallbackTestExpectation ()

@property BOOL executed;

@end

@implementation RTCallbackTestExpectation

+ (instancetype)argsCallbackTextExpectation {
    RTCallbackTestExpectation *expectation = [self callbackTestExpectation];
    
    __weak RTCallbackTestExpectation *weakExpectation = expectation;
    
    expectation.argsCallback = ^(id args) {
        weakExpectation.callbackArguments = args;
        [weakExpectation wasExecuted];
    };
    
    return expectation;
}

+ (instancetype)noArgsCallbackTestExpectation {
    RTCallbackTestExpectation *expectation = [self callbackTestExpectation];
    
    __weak RTCallbackTestExpectation *weakExpectation = expectation;
    
    expectation.noArgsCallback = ^{
        [weakExpectation wasExecuted];
    };
    
    return expectation;
}

+ (instancetype)callbackTestExpectation {
    return [[RTCallbackTestExpectation alloc] init];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.executed = NO;
    }
    return self;
}

- (void)wasExecuted {
    self.executed = YES;
}

- (void)expectCallbackExecuted {
    expect(self.executed).to.beTruthy();
}

- (void)expectCallbackNotExecuted {
    expect(self.executed).to.beFalsy();
}

@end
