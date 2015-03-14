#import "RTUserMessage.h"

@interface RTUserMessage ()

@property (readwrite, copy) NSString *text;
@property (readwrite, copy) NSString *username;

@end

@implementation RTUserMessage

+ (RTUserMessage *)userMessageWithText:(NSString *)text
                           forUsername:(NSString *)username {
    return [[RTUserMessage alloc] initWithText:text forUsername:username];
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
