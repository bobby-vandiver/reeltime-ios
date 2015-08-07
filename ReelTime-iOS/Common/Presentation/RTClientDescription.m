#import "RTClientDescription.h"

@interface RTClientDescription ()

@property (readwrite, copy) NSString *clientId;
@property (readwrite, copy) NSString *clientName;

@end

@implementation RTClientDescription

+ (RTClientDescription *)clientDescriptionWithClientId:(NSString *)clientId
                                            clientName:(NSString *)clientName {

    return [[RTClientDescription alloc] initWithClientId:clientId
                                              clientName:clientName];
}

- (instancetype)initWithClientId:(NSString *)clientId
                      clientName:(NSString *)clientName {
    self = [super init];
    if (self) {
        self.clientId = clientId;
        self.clientName = clientName;
    }
    return self;
}

- (BOOL)isEqualToClientDescription:(RTClientDescription *)clientDescription {
    return [self.clientId isEqual:clientDescription.clientId];
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    
    if (![object isKindOfClass:[RTClientDescription class]]) {
        return NO;
    }
    
    return [self isEqualToClientDescription:(RTClientDescription *)object];
}

- (NSUInteger)hash {
    return [self.clientId hash];
}

@end
