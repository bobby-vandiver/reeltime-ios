#import "RTOAuth2TokenError.h"

@implementation RTOAuth2TokenError

- (instancetype)initWithErrorCode:(NSString *)errorCode
                 errorDescription:(NSString *)errorDescription {
    self = [super init];
    if (self) {
        self.errorCode = errorCode;
        self.errorDescription = errorDescription;
    }
    return self;
}

@end
