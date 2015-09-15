#import "RTRemoveVideoFromReelDataManager.h"
#import "RTAPIClient.h"

#import "RTServerErrors.h"
#import "RTServerErrorsConverter.h"

#import "RTRemoveVideoFromReelServerErrorMapping.h"

@interface RTRemoveVideoFromReelDataManager ()

@property RTAPIClient *client;
@property RTServerErrorsConverter *serverErrorsConverter;

@end

@implementation RTRemoveVideoFromReelDataManager

- (instancetype)initWithClient:(RTAPIClient *)client {
    self = [super init];
    if (self) {
        self.client = client;
        
        RTRemoveVideoFromReelServerErrorMapping *mapping = [[RTRemoveVideoFromReelServerErrorMapping alloc] init];
        self.serverErrorsConverter = [[RTServerErrorsConverter alloc] initWithMapping:mapping];
    }
    return self;
}

- (void)removeVideoForVideoId:(NSUInteger)videoId
            fromReelForReelId:(NSUInteger)reelId
                      success:(NoArgsCallback)success
                      failure:(ErrorCallback)failure {
    
    NoArgsCallback successCallback = ^{
        success();
    };
    
    ServerErrorsCallback failureCallback = ^(RTServerErrors *serverErrors) {
        NSError *error = [self.serverErrorsConverter convertFirstErrorFromServerErrors:serverErrors];
        failure(error);
    };
    
    [self.client removeVideoWithVideoId:videoId
                     fromReelWithReelId:reelId
                                success:successCallback
                                failure:failureCallback];
}

@end
