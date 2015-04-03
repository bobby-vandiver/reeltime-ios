#import "RTBrowseVideosDataManager.h"
#import "RTClient.h"

#import "RTVideo.h"
#import "RTVideoList.h"

#import "RTCountDownLatch.h"
#import "RTLogging.h"

@implementation RTBrowseVideosDataManager

- (void)retrievePage:(NSUInteger)page
            callback:(void (^)(NSArray *))callback {
    
    VideoListCallback successCallback = ^(RTVideoList *videoList) {
        [self retrieveThumbnailsForVideos:videoList.videos callback:callback];
    };
    
    ServerErrorsCallback failureCallback = ^(RTServerErrors *serverErrors) {
        DDLogWarn(@"Failed to retrieve video list: %@", serverErrors);
        callback(@[]);
    };
    
    [self.client listVideosPage:page
                        success:successCallback
                        failure:failureCallback];
}

- (void)retrieveThumbnailsForVideos:(NSArray *)videos
                           callback:(void (^)(NSArray *))callback {
    RTCountDownLatch *countdownLatch = [[RTCountDownLatch alloc] initWithCount:videos.count];
    
    for (RTVideo *video in videos) {
        
        ThumbnailCallback successCallback = ^(RTThumbnail *thumbnail) {
            DDLogDebug(@"Retrieved thumbnail");
            video.thumbnail = thumbnail;
            [countdownLatch countDown];
        };
        
        ServerErrorsCallback failureCallback = ^(RTServerErrors *serverErrors) {
            DDLogWarn(@"Failed to retrieve thumbnail for video: %@", video);
            [countdownLatch countDown];
        };
    
        // TODO: Determine resolution based on iPhone model
        [self.client thumbnailForVideoId:[video.videoId integerValue]
                          withResolution:@"small"
                                 success:successCallback
                                 failure:failureCallback];
    }
    
    [countdownLatch awaitWithCallback:^{
        callback(videos);
    }];
}

@end
