#import "RTTestCommon.h"

#import "RTBrowseVideosDataManager.h"
#import "RTClient.h"

#import "RTVideo.h"
#import "RTVideoList.h"

#import "RTThumbnail.h"

SpecBegin(RTBrowseVideosDataManager)

describe(@"browse videos data manager", ^{
    
    __block RTBrowseVideosDataManager *dataManager;
    
    __block RTClient *client;
    
    beforeEach(^{
        client = mock([RTClient class]);
        dataManager = [[RTBrowseVideosDataManager alloc] initWithClient:client];
    });
    
    describe(@"retrieving a videos list page", ^{
        __block BOOL callbackExecuted;
        __block NSArray *callbackVideos;
        
        void (^callback)(NSArray *) = ^(NSArray *videos) {
            callbackExecuted = YES;
            callbackVideos = videos;
        };
        
        beforeEach(^{
            callbackExecuted = NO;
            [dataManager retrievePage:pageNumber callback:callback];
        });
        
        it(@"should pass videos page to callback on success", ^{
            RTVideo *video = [[RTVideo alloc] initWithVideoId:@(videoId)
                                                        title:@"some video"
                                                    thumbnail:nil];

            RTVideoList *videoList = [[RTVideoList alloc] init];
            videoList.videos = @[video];
            
            MKTArgumentCaptor *videoListCallbackCaptor = [[MKTArgumentCaptor alloc] init];
            
            [verify(client) listVideosPage:pageNumber
                                   success:[videoListCallbackCaptor capture]
                                   failure:anything()];
            
            expect(callbackExecuted).to.beFalsy();
            
            [verifyCount(client, never()) thumbnailForVideoId:videoId
                                               withResolution:@"small"
                                                      success:anything()
                                                      failure:anything()];
            
            VideoListCallback videoListCallbackHandler = [videoListCallbackCaptor value];
            videoListCallbackHandler(videoList);
            
            expect(callbackExecuted).to.beFalsy();
            
            MKTArgumentCaptor *thumbnailCallbackCaptor = [[MKTArgumentCaptor alloc] init];
            
            [verify(client) thumbnailForVideoId:videoId
                                 withResolution:@"small"
                                        success:[thumbnailCallbackCaptor capture]
                                        failure:anything()];

            RTThumbnail *thumbnail = mock([RTThumbnail class]);
            
            ThumbnailCallback thumbnailCallbackHandler = [thumbnailCallbackCaptor value];
            thumbnailCallbackHandler(thumbnail);
            
            expect(callbackExecuted).will.beTruthy();
            
            expect(callbackVideos).willNot.beNil();
            expect(callbackVideos).will.haveCountOf(1);
            
            RTVideo *retrievedVideo = callbackVideos[0];

            expect(retrievedVideo).will.beVideo(@(videoId), @"some video");
            expect(retrievedVideo.thumbnail).will.equal(thumbnail);
        });
        
        it(@"should pass empty list to callback on failure", ^{
            MKTArgumentCaptor *failureCaptor = [[MKTArgumentCaptor alloc] init];
            
            [verify(client) listVideosPage:pageNumber
                                   success:anything()
                                   failure:[failureCaptor capture]];
            
            expect(callbackExecuted).to.beFalsy();
            
            ServerErrorsCallback failureHandler = [failureCaptor value];
            failureHandler(nil);
            
            expect(callbackExecuted).to.beTruthy();
            
            expect(callbackVideos).toNot.beNil();
            expect(callbackVideos).to.haveCountOf(0);
        });
    });
});

SpecEnd