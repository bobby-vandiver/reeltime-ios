#import <Foundation/Foundation.h>

typedef void (^TestCallback)(id);

@interface RTCallbackTestExpectation : NSObject

@property (nonatomic, copy) TestCallback callback;

@property id callbackArguments;

+ (instancetype)callbackTestExpectation;

- (void)wasExecuted;

- (void)expectCallbackExecuted;

- (void)expectCallbackNotExecuted;

@end
