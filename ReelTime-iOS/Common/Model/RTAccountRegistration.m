#import "RTAccountRegistration.h"

@interface RTAccountRegistration ()

@property (nonatomic, readwrite, copy) NSString *username;
@property (nonatomic, readwrite, copy) NSString *password;
@property (nonatomic, readwrite, copy) NSString *email;
@property (nonatomic, readwrite, copy) NSString *displayName;
@property (nonatomic, readwrite, copy) NSString *clientName;

@end

@implementation RTAccountRegistration

- (instancetype)initWithUsername:(NSString *)username
                        password:(NSString *)password
                           email:(NSString *)email
                     displayName:(NSString *)displayName
                      clientName:(NSString *)clientName {
    self = [super init];
    if (self) {
        self.username = username;
        self.password = password;
        self.email = email;
        self.displayName = displayName;
        self.clientName = clientName;
    }
    return self;
}

@end
