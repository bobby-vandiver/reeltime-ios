#import "RTBrowseVideosDataManager.h"
#import "RTBrowseVideosDataManagerDelegate.h"
#import "RTClient.h"

#import "RTVideo.h"
#import "RTVideoList.h"

#import "RTCountDownLatch.h"
#import "RTLogging.h"

@interface RTBrowseVideosDataManager ()

@property id<RTBrowseVideosDataManagerDelegate> delegate;

@end

@implementation RTBrowseVideosDataManager

- (instancetype)initWithDelegate:(id<RTBrowseVideosDataManagerDelegate>)delegate
                          client:(RTClient *)client {
    self = [super initWithClient:client];
    if (self) {
        self.delegate = delegate;
    }
    return self;
}

- (void)retrievePage:(NSUInteger)page
            callback:(void (^)(NSArray *))callback {
    
    VideoListCallback successCallback = ^(RTVideoList *videoList) {
        [self retrieveThumbnailsForVideos:videoList.videos callback:callback];
    };
    
    ServerErrorsCallback failureCallback = ^(RTServerErrors *serverErrors) {
        DDLogWarn(@"Failed to retrieve video list: %@", serverErrors);
        callback(@[]);
    };
    
    [self.delegate listVideosPage:page
                       withClient:self.client
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
