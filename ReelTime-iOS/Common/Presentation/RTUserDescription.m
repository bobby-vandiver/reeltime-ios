#import "RTUserDescription.h"

@interface RTUserDescription ()

@property (readwrite, copy) NSString *displayName;
@property (readwrite, copy) NSString *username;

@end

@implementation RTUserDescription

+ (RTUserDescription *)userDescriptionWithDisplayName:(NSString *)displayName
                                          forUsername:(NSString *)username {
    return [[RTUserDescription alloc] initWithDisplayName:displayName forUsername:username];
}

- (instancetype)initWithDisplayName:(NSString *)displayName
                        forUsername:(NSString *)username {
    self = [super init];
    if (self) {
        self.displayName = displayName;
        self.username = username;
    }
    return self;
}

@end
