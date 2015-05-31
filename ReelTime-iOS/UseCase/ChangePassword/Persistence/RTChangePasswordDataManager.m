#import "RTChangePasswordDataManager.h"
#import "RTAPIClient.h"

#import "RTServerErrorsConverter.h"
#import "RTChangePasswordServerErrorMapping.h"

@interface RTChangePasswordDataManager ()

@property RTAPIClient *client;
@property RTServerErrorsConverter *serverErrorsConverter;

@end

@implementation RTChangePasswordDataManager

- (instancetype)initWithClient:(RTAPIClient *)client {
    self = [super init];
    if (self) {
        self.client = client;
        
        RTChangePasswordServerErrorMapping *mapping = [[RTChangePasswordServerErrorMapping alloc] init];
        self.serverErrorsConverter = [[RTServerErrorsConverter alloc] initWithMapping:mapping];
    }
    return self;
}

- (void)changePassword:(NSString *)password
               changed:(NoArgsCallback)changed
            notChanged:(ArrayCallback)notChanged {

    NoArgsCallback successCallback = ^{
        changed();
    };
    
    ServerErrorsCallback failureCallback = ^(RTServerErrors *serverErrors) {
        NSArray *errors = [self.serverErrorsConverter convertServerErrors:serverErrors];
        notChanged(errors);
    };
    
    [self.client changePassword:password
                        success:successCallback
                        failure:failureCallback];
}

@end
