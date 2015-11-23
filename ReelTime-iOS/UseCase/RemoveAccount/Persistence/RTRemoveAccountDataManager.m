#import "RTRemoveAccountDataManager.h"
#import "RTAPIClient.h"

#import "RTServerErrorsConverter.h"
#import "RTRemoveAccountServerErrorMapping.h"

@interface RTRemoveAccountDataManager ()

@property RTAPIClient *client;
@property RTServerErrorsConverter *serverErrorsConverter;

@end

@implementation RTRemoveAccountDataManager

- (instancetype)initWithClient:(RTAPIClient *)client {
    self = [super init];
    if (self) {
        self.client = client;
        
        RTRemoveAccountServerErrorMapping *mapping = [[RTRemoveAccountServerErrorMapping alloc] init];
        self.serverErrorsConverter = [[RTServerErrorsConverter alloc] initWithMapping:mapping];
    }
    return self;
}

- (void)removeAccount:(NoArgsCallback)success
              failure:(ErrorCallback)failure {

    NoArgsCallback successCallback = ^{
        success();
    };
    
    ServerErrorsCallback failureCallback = ^(RTServerErrors *serverErrors) {
        NSError *error = [self.serverErrorsConverter convertFirstErrorFromServerErrors:serverErrors];
        failure(error);
    };
    
    [self.client removeAccountWithSuccess:successCallback
                                  failure:failureCallback];
}

@end
