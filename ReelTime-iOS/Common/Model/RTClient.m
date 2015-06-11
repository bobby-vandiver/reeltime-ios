#import "RTClient.h"

@implementation RTClient

- (instancetype)initWithClientId:(NSString *)clientId
                      clientName:(NSString *)clientName {
    self = [super init];
    if (self) {
        self.clientId = clientId;
        self.clientName = clientName;
    }
    return self;
}

- (BOOL)isEqualToClient:(RTClient *)client {
    return [self.clientId isEqual:client.clientId];
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    
    if (![object isKindOfClass:[RTClient class]]) {
        return NO;
    }
    
    return [self isEqualToClient:(RTClient *)object];
}

- (NSUInteger)hash {
    return [self.clientId hash];
}

@end
