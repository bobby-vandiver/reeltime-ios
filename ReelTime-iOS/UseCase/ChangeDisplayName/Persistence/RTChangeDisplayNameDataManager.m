#import "RTChangeDisplayNameDataManager.h"
#import "RTAPIClient.h"

#import "RTServerErrorsConverter.h"
#import "RTChangeDisplayNameServerErrorMapping.h"

@interface RTChangeDisplayNameDataManager ()

@property RTAPIClient *client;
@property RTServerErrorsConverter *serverErrorsConverter;

@end

@implementation RTChangeDisplayNameDataManager

- (instancetype)initWithClient:(RTAPIClient *)client {
    self = [super init];
    if (self) {
        self.client = client;
        
        RTChangeDisplayNameServerErrorMapping *mapping = [[RTChangeDisplayNameServerErrorMapping alloc] init];
        self.serverErrorsConverter = [[RTServerErrorsConverter alloc] initWithMapping:mapping];
    }
    return self;
}

- (void	)changeDisplayName:(NSString *)displayName
                   changed:(NoArgsCallback)changed
                notChanged:(ArrayCallback)notChanged {

    NoArgsCallback successCallback = ^{
        changed();
    };
    
    ServerErrorsCallback failureCallback = ^(RTServerErrors *serverErrors) {
        NSArray *errors = [self.serverErrorsConverter convertServerErrors:serverErrors];
        notChanged(errors);
    };
    
    [self.client changeDisplayName:displayName
                           success:successCallback
                           failure:failureCallback];
}

@end
