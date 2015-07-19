#import "RTJoinAudienceDataManager.h"
#import "RTAPIClient.h"

#import "RTServerErrors.h"
#import "RTJoinAudienceError.h"

#import "RTErrorFactory.h"
#import "RTLogging.h"

@interface RTJoinAudienceDataManager ()

@property RTAPIClient *client;

@end

@implementation RTJoinAudienceDataManager

- (instancetype)initWithClient:(RTAPIClient *)client {
    self = [super init];
    if (self) {
        self.client = client;
    }
    return self;
}

- (void)requestAudienceMembershipForReelId:(NSNumber *)reelId
                               joinSuccess:(NoArgsCallback)success
                               joinFailure:(ErrorCallback)failure {
    
    NoArgsCallback successCallback = ^{
        success();
    };

    ServerErrorsCallback failureCallback = ^(RTServerErrors *serverErrors) {
        NSError *error;

        if ([serverErrors.errors[0] isEqual:@"Requested reel was not found"]) {
            error = [RTErrorFactory joinAudienceErrorWithCode:RTJoinAudienceErrorReelNotFound];
        }
        else {
            DDLogWarn(@"Unknown join error(s): %@", serverErrors);
            error = [RTErrorFactory joinAudienceErrorWithCode:RTJoinAudienceErrorUnknownError];
        }
        
        failure(error);
    };
    
    [self.client joinAudienceForReelWithReelId:[reelId integerValue]
                                       success:successCallback
                                       failure:failureCallback];
}

@end
