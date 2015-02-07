#import "RTConditionalMessage.h"

@interface RTConditionalMessage ()

@property (readwrite) BOOL condition;
@property (readwrite, copy) NSString *message;

@end

@implementation RTConditionalMessage

+ (RTConditionalMessage *)trueWithMessage:(NSString *)message {
    return [[RTConditionalMessage alloc] initWithCondition:YES message:message];
}

+ (RTConditionalMessage *)falseWithMessage:(NSString *)message {
    return [[RTConditionalMessage alloc] initWithCondition:NO message:message];
}

- (instancetype)initWithCondition:(BOOL)condition
                          message:(NSString *)message {
    self = [super init];
    if (self) {
        self.condition = condition;
        self.message = message;
    }
    return self;
}

@end
