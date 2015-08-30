#import "RTAddVideoToReelDataManager.h"
#import "RTAPIClient.h"

#import "RTServerErrors.h"
#import "RTAddVideoToReelError.h"

#import "RTErrorFactory.h"
#import "RTLogging.h"

@interface RTAddVideoToReelDataManager ()

@property RTAPIClient *client;

@end

@implementation RTAddVideoToReelDataManager

- (instancetype)initWithClient:(RTAPIClient *)client {
    self = [super init];
    if (self) {
        self.client = client;
    }
    return self;
}

- (void)addVideoForVideoId:(NSUInteger)videoId
           toReelForReelId:(NSUInteger)reelId
                   success:(NoArgsCallback)success
                   failure:(ErrorCallback)failure {
    
    NoArgsCallback successCallback = ^{
        success();
    };
    
    ServerErrorsCallback failureCallback = ^(RTServerErrors *serverErrors) {
        NSError *error;

        NSString *errorMessage = serverErrors.errors[0];
        
        if ([errorMessage isEqual:@"Requested video was not found"]) {
            error = [RTErrorFactory addVideoToReelErrorWithCode:RTAddVideoToReelErrorVideoNotFound];
        }
        else if ([errorMessage isEqual:@"Requested reel was not found"]) {
            error = [RTErrorFactory addVideoToReelErrorWithCode:RTAddVideoToReelErrorReelNotFound];
        }
        else if ([errorMessage isEqual:@"Unauthorized operation requested"]) {
            error = [RTErrorFactory addVideoToReelErrorWithCode:RTAddVideoToReelErrorUnauthorized];
        }
        else {
            DDLogWarn(@"Unknown add video to reel error(s): %@", serverErrors);
            error = [RTErrorFactory addVideoToReelErrorWithCode:RTAddVideoToReelErrorUnknownError];
        }
        
        failure(error);
    };
    
    [self.client addVideoWithVideoId:videoId
                    toReelWithReelId:reelId
                             success:successCallback
                             failure:failureCallback];
}

@end
