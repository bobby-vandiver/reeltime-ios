#import "RTLeaveAudienceDataManager.h"
#import "RTAPIClient.h"

#import "RTServerErrors.h"
#import "RTLeaveAudienceError.h"

#import "RTErrorFactory.h"
#import "RTLogging.h"

@interface RTLeaveAudienceDataManager ()

@property RTAPIClient *client;

@end

@implementation RTLeaveAudienceDataManager

- (instancetype)initWithClient:(RTAPIClient *)client {
    self = [super init];
    if (self) {
        self.client = client;
    }
    return self;
}

- (void)requestAudienceLeaveForReelId:(NSNumber *)reelId
                         leaveSuccess:(NoArgsCallback)leaveSuccess
                         leaveFailure:(ErrorCallback)leaveFailure {
    
    NoArgsCallback successCallback = ^{
        leaveSuccess();
    };
    
    ServerErrorsCallback failureCallback = ^(RTServerErrors *serverErrors) {
        NSError *error;
        
        if ([serverErrors.errors[0] isEqual:@"Requested reel was not found"]) {
            error = [RTErrorFactory leaveAudienceErrorWithCode:RTLeaveAudienceErrorReelNotFound];
        }
        else {
            DDLogWarn(@"Unknown leave error(s): %@", serverErrors);
            error = [RTErrorFactory leaveAudienceErrorWithCode:RTLeaveAudienceErrorUnknownError];
        }
        
        leaveFailure(error);
    };
 
    [self.client leaveAudienceForReelWithReelId:[reelId integerValue]
                                        success:successCallback
                                        failure:failureCallback];
}

@end
