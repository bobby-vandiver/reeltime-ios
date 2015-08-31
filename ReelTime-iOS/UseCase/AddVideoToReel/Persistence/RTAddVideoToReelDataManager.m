#import "RTAddVideoToReelDataManager.h"
#import "RTAPIClient.h"

#import "RTServerErrors.h"
#import "RTServerErrorsConverter.h"

#import "RTAddVideoToReelServerErrorMapping.h"

@interface RTAddVideoToReelDataManager ()

@property RTAPIClient *client;
@property RTServerErrorsConverter *serverErrorsConverter;

@end

@implementation RTAddVideoToReelDataManager

- (instancetype)initWithClient:(RTAPIClient *)client {
    self = [super init];
    if (self) {
        self.client = client;
    
        RTAddVideoToReelServerErrorMapping *mapping = [[RTAddVideoToReelServerErrorMapping alloc] init];
        self.serverErrorsConverter = [[RTServerErrorsConverter alloc] initWithMapping:mapping];
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
        NSError *error = [self.serverErrorsConverter convertFirstErrorFromServerErrors:serverErrors];
        failure(error);
    };
    
    [self.client addVideoWithVideoId:videoId
                    toReelWithReelId:reelId
                             success:successCallback
                             failure:failureCallback];
}

@end
