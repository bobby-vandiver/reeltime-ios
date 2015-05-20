#import "RTBrowseVideosDataManager.h"
#import "RTBrowseVideosDataManagerDelegate.h"

#import "RTClient.h"
#import "RTThumbnailSupport.h"

#import "RTVideo.h"
#import "RTVideoList.h"

#import "RTCountDownLatch.h"
#import "RTLogging.h"

@interface RTBrowseVideosDataManager ()

@property id<RTBrowseVideosDataManagerDelegate> delegate;
@property RTThumbnailSupport *thumbnailSupport;

@end

@implementation RTBrowseVideosDataManager

- (instancetype)initWithDelegate:(id<RTBrowseVideosDataManagerDelegate>)delegate
                thumbnailSupport:(RTThumbnailSupport *)thumbnailSupport
                          client:(RTClient *)client {
    self = [super initWithClient:client];
    if (self) {
        self.delegate = delegate;
        self.thumbnailSupport = thumbnailSupport;
    }
    return self;
}

- (void)retrievePage:(NSUInteger)page
            callback:(ArrayCallback)callback {
    
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
                           callback:(ArrayCallback)callback {
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
    
        NSString *resolution = [self thumbnailResolutionValue];
        
        [self.client thumbnailForVideoId:[video.videoId integerValue]
                          withResolution:resolution
                                 success:successCallback
                                 failure:failureCallback];
    }
    
    dispatch_queue_t mainQueue = dispatch_get_main_queue();

    [countdownLatch awaitExecutionOnQueue:mainQueue withCallback:^{
        callback(videos);
    }];
}

- (NSString *)thumbnailResolutionValue {
    RTThumbnailResolution resolution = [self.thumbnailSupport resolution];

    if (resolution == RTThumbnailResolution1X) {
        return @"small";
    }
    else if (resolution == RTThumbnailResolution2X) {
        return @"medium";
    }
    
    return @"large";
}

@end
