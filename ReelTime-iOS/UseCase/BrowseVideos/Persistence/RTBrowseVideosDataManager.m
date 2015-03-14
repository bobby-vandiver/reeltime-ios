#import "RTBrowseVideosDataManager.h"
#import "RTClient.h"

#import "RTVideoList.h"
#import "RTLogging.h"

@implementation RTBrowseVideosDataManager

- (void)retrievePage:(NSUInteger)page
            callback:(void (^)(NSArray *))callback {
    
    VideoListCallback successCallback = ^(RTVideoList *videoList) {
        callback(videoList.videos);
    };
    
    ServerErrorsCallback failureCallback = ^(RTServerErrors *serverErrors) {
        DDLogWarn(@"Failed to retrieve video list: %@", serverErrors);
        callback(@[]);
    };
    
    [self.client listVideosPage:page
                        success:successCallback
                        failure:failureCallback];
}

@end
