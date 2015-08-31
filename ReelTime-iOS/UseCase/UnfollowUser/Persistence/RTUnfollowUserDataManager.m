#import "RTUnfollowUserDataManager.h"
#import "RTAPIClient.h"

#import "RTServerErrors.h"
#import "RTServerErrorsConverter.h"

#import "RTUnfollowUserServerErrorMapping.h"

@interface RTUnfollowUserDataManager ()

@property RTAPIClient *client;
@property RTServerErrorsConverter *serverErrorsConverter;


@end

@implementation RTUnfollowUserDataManager

- (instancetype)initWithClient:(RTAPIClient *)client {
    self = [super init];
    if (self) {
        self.client = client;
        
        RTUnfollowUserServerErrorMapping *mapping = [[RTUnfollowUserServerErrorMapping alloc] init];
        self.serverErrorsConverter = [[RTServerErrorsConverter alloc] initWithMapping:mapping];
    }
    return self;
}

- (void)unfollowUserWithUsername:(NSString *)username
                 unfollowSuccess:(NoArgsCallback)success
                 unfollowFailure:(ErrorCallback)failure {

    NoArgsCallback successCallback = ^{
        success();
    };
    
    ServerErrorsCallback failureCallback = ^(RTServerErrors *serverErrors) {
        NSError *error = [self.serverErrorsConverter convertFirstErrorFromServerErrors:serverErrors];
        failure(error);
    };
    
    [self.client unfollowUserForUsername:username
                                 success:successCallback
                                 failure:failureCallback];
}

@end
