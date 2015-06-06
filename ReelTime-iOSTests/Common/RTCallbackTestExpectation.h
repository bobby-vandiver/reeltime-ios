#import <Foundation/Foundation.h>

typedef void (^TestArgsCallback)(id);
typedef void (^TestNoArgsCallback)();

@interface RTCallbackTestExpectation : NSObject

@property (nonatomic, copy) TestArgsCallback argsCallback;
@property (nonatomic, copy) TestNoArgsCallback noArgsCallback;

@property id callbackArguments;

+ (instancetype)noArgsCallbackTestExpectation;

+ (instancetype)argsCallbackTextExpectation;

- (void)wasExecuted;

- (void)expectCallbackExecuted;

- (void)expectCallbackNotExecuted;

@end
