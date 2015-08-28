#import "RTDeleteVideoDataManager.h"
#import "RTAPIClient.h"

#import "RTServerErrors.h"
#import "RTDeleteVideoError.h"

#import "RTErrorFactory.h"
#import "RTLogging.h"

@interface RTDeleteVideoDataManager ()

@property RTAPIClient *client;

@end

@implementation RTDeleteVideoDataManager

- (instancetype)initWithClient:(RTAPIClient *)client {
    self = [super init];
    if (self) {
        self.client = client;
    }
    return self;
}

- (void)deleteVideoForVideoId:(NSUInteger)videoId
                      success:(NoArgsCallback)success
                      failure:(ErrorCallback)failure {

    NoArgsCallback successCallback = ^{
        success();
    };
    
    ServerErrorsCallback failureCallback = ^(RTServerErrors *serverErrors) {
        NSError *error;
        
        if ([serverErrors.errors[0] isEqual:@"Requested video was not found"]) {
            error = [RTErrorFactory deleteVideoErrorWithCode:RTDeleteVideoErrorVideoNotFound];
        }
        else {
            DDLogWarn(@"Unknown video deletion error(s): %@", serverErrors);
            error = [RTErrorFactory deleteVideoErrorWithCode:RTDeleteVideoErrorUnknownError];
        }
        
        failure(error);
    };
    
    [self.client deleteVideoForVideoId:videoId
                               success:successCallback
                               failure:failureCallback];
}

@end
