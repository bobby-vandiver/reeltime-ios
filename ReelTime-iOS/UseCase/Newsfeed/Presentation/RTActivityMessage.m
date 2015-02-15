#import "RTActivityMessage.h"

@interface RTActivityMessage ()

@property (readwrite) RTStringWithEmbeddedLinks *message;
@property (readwrite) RTActivityType type;

@end

@implementation RTActivityMessage

+ (RTActivityMessage *)activityMessage:(RTStringWithEmbeddedLinks *)message
                              withType:(RTActivityType)type {
    return [[RTActivityMessage alloc] initWithMessage:message withType:type];
}

- (instancetype)initWithMessage:(RTStringWithEmbeddedLinks *)message
                       withType:(RTActivityType)type {
    self = [super init];
    if (self) {
        self.message = message;
        self.type = type;
    }
    return self;
}

@end
