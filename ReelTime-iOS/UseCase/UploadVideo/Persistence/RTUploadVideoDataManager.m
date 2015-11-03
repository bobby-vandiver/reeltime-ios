#import "RTUploadVideoDataManager.h"
#import "RTAPIClient.h"

@interface RTUploadVideoDataManager ()

@property RTAPIClient *client;

@end

@implementation RTUploadVideoDataManager

- (instancetype)initWithClient:(RTAPIClient *)client {
    self = [super init];
    if (self) {
        self.client = client;
    }
    return self;
}

- (void)uploadVideo:(NSURL *)videoUrl
          thumbnail:(NSURL *)thumbnailUrl
          withTitle:(NSString *)title
             toReel:(NSString *)reel
            success:(VideoCallback)success
            failure:(ArrayCallback)failure {

    VideoCallback successCallback = ^(RTVideo *video) {
        success(video);
    };
    
    ServerErrorsCallback failureCallback = ^(RTServerErrors *serverErrors) {
        
    };
    
    [self.client addVideoFromFileURL:videoUrl
                thumbnailFromFileURL:thumbnailUrl
                           withTitle:title
                      toReelWithName:reel
                             success:successCallback
                             failure:failureCallback];
}

@end
