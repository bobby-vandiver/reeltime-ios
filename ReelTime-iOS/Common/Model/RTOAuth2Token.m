#import "RTOAuth2Token.h"

@implementation RTOAuth2Token

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (instancetype)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) {
        self.accessToken = [decoder decodeObjectOfClass:[NSString class] forKey:@"accessToken"];
        self.refreshToken = [decoder decodeObjectOfClass:[NSString class] forKey:@"refreshToken"];
        self.tokenType = [decoder decodeObjectOfClass:[NSString class] forKey:@"tokenType"];
        self.expiresIn = [decoder decodeObjectOfClass:[NSNumber class] forKey:@"expiresIn"];
        self.scope = [decoder decodeObjectOfClass:[NSString class] forKey:@"scope"];
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.accessToken forKey:@"accessToken"];
    [encoder encodeObject:self.refreshToken forKey:@"refreshToken"];
    [encoder encodeObject:self.tokenType forKey:@"tokenType"];
    [encoder encodeObject:self.expiresIn forKey:@"expiresIn"];
    [encoder encodeObject:self.scope forKey:@"scope"];
}

@end
