#import "RTUploadVideoDataManager.h"
#import "RTAPIClient.h"

#import "RTServerErrors.h"
#import "RTServerErrorsConverter.h"

#import "RTUploadVideoServerErrorMapping.h"

@interface RTUploadVideoDataManager ()

@property RTAPIClient *client;
@property RTServerErrorsConverter *serverErrorsConverter;

@end

@implementation RTUploadVideoDataManager

- (instancetype)initWithClient:(RTAPIClient *)client {
    self = [super init];
    if (self) {
        self.client = client;
        
        RTUploadVideoServerErrorMapping *mapping = [[RTUploadVideoServerErrorMapping alloc] init];
        self.serverErrorsConverter = [[RTServerErrorsConverter alloc] initWithMapping:mapping];
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
        NSArray *uploadErrors = [self.serverErrorsConverter convertServerErrors:serverErrors];
        failure(uploadErrors);
    };
    
    [self.client addVideoFromFileURL:videoUrl
                thumbnailFromFileURL:thumbnailUrl
                           withTitle:title
                      toReelWithName:reel
                             success:successCallback
                             failure:failureCallback];
}

@end
