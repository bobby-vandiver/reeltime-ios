#import "RTTestCommon.h"

#import "RTBrowseVideosDataManager.h"
#import "RTBrowseVideosDataManagerDelegate.h"

#import "RTAPIClient.h"
#import "RTThumbnailSupport.h"

#import "RTVideo.h"
#import "RTVideoList.h"

#import "RTThumbnail.h"

@interface RTBrowseVideosDataManager (Test)

- (void)retrieveThumbnailsForVideos:(NSArray *)videos
                           callback:(void (^)(NSArray *))callback;
@end

SpecBegin(RTBrowseVideosDataManager)

describe(@"browse videos data manager", ^{
    
    __block RTBrowseVideosDataManager *dataManager;
    __block id<RTBrowseVideosDataManagerDelegate> delegate;

    __block RTThumbnailSupport *thumbnailSupport;
    __block RTAPIClient *client;
    
    beforeEach(^{
        delegate = mockProtocol(@protocol(RTBrowseVideosDataManagerDelegate));
        
        thumbnailSupport = mock([RTThumbnailSupport class]);
        client = mock([RTAPIClient class]);

        dataManager = [[RTBrowseVideosDataManager alloc] initWithDelegate:delegate
                                                         thumbnailSupport:thumbnailSupport
                                                                   client:client];
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
        });
        
        describe(@"successful retrieval", ^{
            __block RTVideo *video;
            __block RTVideoList *videoList;
        
            __block RTThumbnail *thumbnail;
            
            __block MKTArgumentCaptor *videoListCallbackCaptor;
            __block MKTArgumentCaptor *thumbnailCallbackCaptor;
            
            beforeEach(^{
                video = [[RTVideo alloc] initWithVideoId:@(videoId)
                                                   title:@"some video"
                                               thumbnail:nil];
                
                videoList = [[RTVideoList alloc] init];
                videoList.videos = @[video];

                unsigned char bytes[] = { 1, 2, 3, 4 };
                NSData *data = [NSData dataWithBytes:bytes length:sizeof(bytes)];
                thumbnail = [[RTThumbnail alloc] initWithData:data];

                videoListCallbackCaptor = [[MKTArgumentCaptor alloc] init];
                thumbnailCallbackCaptor = [[MKTArgumentCaptor alloc] init];
            });
            
            afterEach(^{
                ThumbnailCallback thumbnailCallbackHandler = [thumbnailCallbackCaptor value];
                thumbnailCallbackHandler(thumbnail);
                
                expect(callbackExecuted).will.beTruthy();
                
                expect(callbackVideos).willNot.beNil();
                expect(callbackVideos).will.haveCountOf(1);
                
                RTVideo *retrievedVideo = callbackVideos[0];
                
                expect(retrievedVideo).will.beVideo(@(videoId), @"some video");
                expect(retrievedVideo.thumbnail).will.equal(thumbnail);
            });
            
            it(@"should request thumbnails and pass videos page to callback on success", ^{
                [dataManager retrievePage:pageNumber callback:callback];
                
                [verify(delegate) listVideosPage:pageNumber
                                      withClient:client
                                         success:[videoListCallbackCaptor capture]
                                         failure:anything()];
                
                expect(callbackExecuted).to.beFalsy();
                
                [verifyCount(client, never()) thumbnailForVideoId:videoId
                                                   withResolution:anything()
                                                          success:anything()
                                                          failure:anything()];
                
                VideoListCallback videoListCallbackHandler = [videoListCallbackCaptor value];
                videoListCallbackHandler(videoList);
                
                expect(callbackExecuted).to.beFalsy();
                
                [verify(client) thumbnailForVideoId:videoId
                                     withResolution:anything()
                                            success:[thumbnailCallbackCaptor capture]
                                            failure:anything()];
            });
            
            describe(@"resolution of requested thumbnails", ^{
                
                it(@"resolution 1x", ^{
                    [given([thumbnailSupport resolution]) willReturnInteger:RTThumbnailResolution1X];
                    
                    [dataManager retrieveThumbnailsForVideos:videoList.videos callback:callback];

                    [verify(client) thumbnailForVideoId:videoId
                                         withResolution:@"small"
                                                success:[thumbnailCallbackCaptor capture]
                                                failure:anything()];
                });
                
                it(@"resolution 2x", ^{
                    [given([thumbnailSupport resolution]) willReturnInteger:RTThumbnailResolution2X];
                    
                    [dataManager retrieveThumbnailsForVideos:videoList.videos callback:callback];
                    
                    [verify(client) thumbnailForVideoId:videoId
                                         withResolution:@"medium"
                                                success:[thumbnailCallbackCaptor capture]
                                                failure:anything()];
                });
                
                it(@"resolution 3x", ^{
                    [given([thumbnailSupport resolution]) willReturnInteger:RTThumbnailResolution3X];
                    
                    [dataManager retrieveThumbnailsForVideos:videoList.videos callback:callback];
                    
                    [verify(client) thumbnailForVideoId:videoId
                                         withResolution:@"large"
                                                success:[thumbnailCallbackCaptor capture]
                                                failure:anything()];
                });
            });
        });
        
        describe(@"failed retrieval", ^{
            it(@"should pass empty list to callback on failure", ^{
                [dataManager retrievePage:pageNumber callback:callback];
                
                MKTArgumentCaptor *failureCaptor = [[MKTArgumentCaptor alloc] init];
                
                [verify(delegate) listVideosPage:pageNumber
                                      withClient:client
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
});

SpecEnd