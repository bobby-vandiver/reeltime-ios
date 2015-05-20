#import "RTPagedListDataManager.h"
#import "RTClient.h"
#import "RTException.h"

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
            callback:(ArrayCallback)callback {
    [NSException raise:RTAbstractMethodException
                format:@"Cannot invoke abstract method"];
}

@end
