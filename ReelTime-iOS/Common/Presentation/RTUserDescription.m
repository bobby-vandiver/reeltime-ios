#import "RTUserDescription.h"

@interface RTUserDescription ()

@property (readwrite, copy) NSString *text;
@property (readwrite, copy) NSString *username;

@end

@implementation RTUserDescription

+ (RTUserDescription *)userDescriptionWithText:(NSString *)text
                                   forUsername:(NSString *)username {
    return [[RTUserDescription alloc] initWithText:text forUsername:username];
}

- (instancetype)initWithText:(NSString *)text
                 forUsername:(NSString *)username {
    self = [super init];
    if (self) {
        self.text = text;
        self.username = username;
    }
    return self;
}

@end
