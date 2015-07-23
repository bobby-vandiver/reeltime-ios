#import "RTUnfollowUserDataManager.h"
#import "RTAPIClient.h"

#import "RTServerErrors.h"
#import "RTUnfollowUserError.h"

#import "RTErrorFactory.h"
#import "RTLogging.h"

@interface RTUnfollowUserDataManager ()

@property RTAPIClient *client;

@end

@implementation RTUnfollowUserDataManager

- (instancetype)initWithClient:(RTAPIClient *)client {
    self = [super init];
    if (self) {
        self.client = client;
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
        NSError *error;
        
        if ([serverErrors.errors[0] isEqual:@"Requested user was not found"]) {
            error = [RTErrorFactory unfollowUserErrorWithCode:RTUnfollowUserErrorUserNotFound];
        }
        else {
            DDLogWarn(@"Unknown unfollow error(s): %@", serverErrors);
            error = [RTErrorFactory unfollowUserErrorWithCode:RTUnfollowUserErrorUnknownError];
        }
        
        failure(error);
    };
    
    [self.client unfollowUserForUsername:username
                                 success:successCallback
                                 failure:failureCallback];
}

@end
