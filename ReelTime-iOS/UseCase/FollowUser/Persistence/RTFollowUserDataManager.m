#import "RTFollowUserDataManager.h"
#import "RTAPIClient.h"

#import "RTServerErrors.h"
#import "RTFollowUserError.h"

#import "RTErrorFactory.h"
#import "RTLogging.h"

@interface RTFollowUserDataManager ()

@property RTAPIClient *client;

@end

@implementation RTFollowUserDataManager

- (instancetype)initWithClient:(RTAPIClient *)client {
    self = [super init];
    if (self) {
        self.client = client;
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
        NSError *error;
        
        if ([serverErrors.errors[0] isEqual:@"Requested user was not found"]) {
            error = [RTErrorFactory followUserErrorWithCode:RTFollowUserErrorUserNotFound];
        }
        else {
            DDLogWarn(@"Unknown follow error(s): %@", serverErrors);
            error = [RTErrorFactory followUserErrorWithCode:RTFollowUserErrorUnknownError];
        }
        
        failure(error);
    };
    
    [self.client followUserForUsername:username
                               success:successCallback
                               failure:failureCallback];
}

@end
