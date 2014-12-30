#import "RTClientCredentials.h"

@implementation RTClientCredentials

- (instancetype)initWithClientId:(NSString *)clientId clientSecret:(NSString *)clientSecret {
    self = [super init];
    if (self) {
        self.clientId = clientId;
        self.clientSecret = clientSecret;
    }
    return self;
}

@end
