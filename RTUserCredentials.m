#import "RTUserCredentials.h"

@interface RTUserCredentials ()

@property (nonatomic, readwrite, copy) NSString *username;
@property (nonatomic, readwrite, copy) NSString *password;

@end

@implementation RTUserCredentials

- (instancetype)initWithUsername:(NSString *)username
                        password:(NSString *)password {
    self = [super init];
    if (self) {
        self.username = username;
        self.password = password;
    }
    return self;
}

@end
