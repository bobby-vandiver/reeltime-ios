#import "RTPagedListDataManager.h"
#import "RTClient.h"

@interface RTPagedListDataManager ()

@property (readwrite) RTClient *client;

@end

@implementation RTPagedListDataManager

- (instancetype)initWithClient:(RTClient *)client {
    self = [super init];
    if (self) {
        self.client = client;
    }
    return self;
}

- (void)retrievePage:(NSUInteger)page
            callback:(void (^)(NSArray *items))callback {
    [NSException raise:@"RTIllegalInvocation"
                format:@"This message must be implemented by subclasses"];
}

@end
