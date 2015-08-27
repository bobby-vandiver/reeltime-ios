#import "RTDeleteVideoDataManager.h"
#import "RTAPIClient.h"

#import "RTDeleteVideoError.h"

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
        
    };
    
    [self.client deleteVideoForVideoId:videoId
                               success:successCallback
                               failure:failureCallback];
}

@end
