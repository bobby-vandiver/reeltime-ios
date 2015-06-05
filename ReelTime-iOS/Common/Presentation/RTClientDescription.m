#import "RTClientDescription.h"

@interface RTClientDescription ()

@property (readwrite, copy) NSString *clientId;
@property (readwrite, copy) NSString *clientName;

@end

@implementation RTClientDescription

+ (RTClientDescription *)clientDescriptionWithClientId:(NSString *)clientId
                                            clientName:(NSString *)clientName {

    return [[RTClientDescription alloc] initWithClientId:clientId
                                              clientName:clientName];
}

- (instancetype)initWithClientId:(NSString *)clientId
                      clientName:(NSString *)clientName {
    self = [super init];
    if (self) {
        self.clientId = clientId;
        self.clientName = clientName;
    }
    return self;
}

@end
