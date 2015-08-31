#import "RTFollowUserDataManager.h"
#import "RTAPIClient.h"

#import "RTServerErrors.h"
#import "RTServerErrorsConverter.h"

#import "RTFollowUserServerErrorMapping.h"

@interface RTFollowUserDataManager ()

@property RTAPIClient *client;
@property RTServerErrorsConverter *serverErrorsConverter;

@end

@implementation RTFollowUserDataManager

- (instancetype)initWithClient:(RTAPIClient *)client {
    self = [super init];
    if (self) {
        self.client = client;
        
        RTFollowUserServerErrorMapping *mapping = [[RTFollowUserServerErrorMapping alloc] init];
        self.serverErrorsConverter = [[RTServerErrorsConverter alloc] initWithMapping:mapping];
    }
    return self;
}

- (void)followUserWithUsername:(NSString *)username
                 followSuccess:(NoArgsCallback)success
                 followFailure:(ErrorCallback)failure {

    NoArgsCallback successCallback = ^{
        success();
    };
    
    ServerErrorsCallback failureCallback = ^(RTServerErrors *serverErrors) {
        NSError *error = [self.serverErrorsConverter convertFirstErrorFromServerErrors:serverErrors];
        failure(error);
    };
    
    [self.client followUserForUsername:username
                               success:successCallback
                               failure:failureCallback];
}

@end
