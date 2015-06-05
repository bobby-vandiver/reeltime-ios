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

@end
