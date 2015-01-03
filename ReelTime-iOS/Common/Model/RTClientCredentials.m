#import "RTClientCredentials.h"

@implementation RTClientCredentials

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (instancetype)initWithClientId:(NSString *)clientId clientSecret:(NSString *)clientSecret {
    self = [super init];
    if (self) {
        self.clientId = clientId;
        self.clientSecret = clientSecret;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)decoder {
    NSString *clientId = [decoder decodeObjectOfClass:[NSString class] forKey:@"clientId"];
    NSString *clientSecret = [decoder decodeObjectOfClass:[NSString class] forKey:@"clientSecret"];

    return [self initWithClientId:clientId
                     clientSecret:clientSecret];
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.clientId forKey:@"clientId"];
    [encoder encodeObject:self.clientSecret forKey:@"clientSecret"];
}

@end
