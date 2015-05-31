#import "RTPagedListDataManager.h"
#import "RTAPIClient.h"
#import "RTException.h"

@interface RTPagedListDataManager ()

@property (readwrite) RTAPIClient *client;

@end

@implementation RTPagedListDataManager

- (instancetype)initWithClient:(RTAPIClient *)client {
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
