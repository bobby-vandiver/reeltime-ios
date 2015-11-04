#import "RTTestCommon.h"
#import "RTServerErrorMessageToErrorCodeTestHelper.h"

#import "RTUploadVideoDataManager.h"
#import "RTUploadVideoError.h"

#import "RTAPIClient.h"
#import "RTVideo.h"

SpecBegin(RTUploadVideoDataManager)

describe(@"upload video data manager", ^{
    
    __block RTUploadVideoDataManager *dataManager;
    __block RTAPIClient *client;
    
    __block RTServerErrorMessageToErrorCodeTestHelper *helper;

    __block NSURL *videoUrl;
    __block NSURL *thumbnailUrl;
    
    __block RTVideo *video;
    
    __block MKTArgumentCaptor *successCaptor;
    __block MKTArgumentCaptor *failureCaptor;
    
    beforeEach(^{
        client = mock([RTAPIClient class]);
        dataManager = [[RTUploadVideoDataManager alloc] initWithClient:client];
        
        videoUrl = mock([NSURL class]);
        thumbnailUrl = mock([NSURL class]);
        
        video = mock([RTVideo class]);
        
        successCaptor = [[MKTArgumentCaptor alloc] init];
        failureCaptor = [[MKTArgumentCaptor alloc] init];
    });
    
    describe(@"uploading a video to a reel", ^{
        __block RTCallbackTestExpectation *videoUploadSuccees;
        __block RTCallbackTestExpectation *videoUploadFailure;
        
        beforeEach(^{
            videoUploadSuccees = [RTCallbackTestExpectation argsCallbackTextExpectation];
            videoUploadFailure = [RTCallbackTestExpectation argsCallbackTextExpectation];
            
            [dataManager uploadVideo:videoUrl
                           thumbnail:thumbnailUrl
                           withTitle:videoTitle
                              toReel:reelName
                             success:videoUploadSuccees.argsCallback
                             failure:videoUploadFailure.argsCallback];
            
            [verify(client) addVideoFromFileURL:videoUrl
                           thumbnailFromFileURL:thumbnailUrl
                                      withTitle:videoTitle
                                 toReelWithName:reelName
                                        success:[successCaptor capture]
                                        failure:[failureCaptor capture]];
            
            [videoUploadSuccees expectCallbackNotExecuted];
            [videoUploadFailure expectCallbackNotExecuted];
            
            ServerErrorsCallback failureHandler = [failureCaptor value];
            
            NSArray *(^errorRetrievalBlock)() = ^{
                return videoUploadFailure.callbackArguments;
            };
            
            helper = [[RTServerErrorMessageToErrorCodeTestHelper alloc] initForErrorDomain:RTUploadVideoErrorDomain
                                                                        withFailureHandler:failureHandler
                                                                       errorRetrievalBlock:errorRetrievalBlock];
        });
        
        it(@"should pass video to callback on successful upload", ^{
            VideoCallback successCallback = [successCaptor value];
            successCallback(video);
            
            [videoUploadSuccees expectCallbackExecuted];
            expect(videoUploadSuccees.callbackArguments).to.equal(video);
        });
        
        it(@"should map server errors to domain specific errors", ^{
            NSDictionary *mapping = @{
                                      @"Unable to create video. Please try again.":
                                          @(RTUploadVideoErrorServiceUnavailable),
                                      @"Unable to analyze video. Please try again.":
                                          @(RTUploadVideoErrorServiceUnavailable),
                                      
                                      @"[title] is required":
                                          @(RTUploadVideoErrorMissingVideoTitle),
                                      @"[title] is invalid":
                                          @(RTUploadVideoErrorInvalidVideoTitle),
                                      
                                      @"[reel] is required":
                                          @(RTUploadVideoErrorMissingReelName),
                                      @"[reel] is invalid":
                                          @(RTUploadVideoErrorInvalidReelName),
                                      @"[reel] is unknown":
                                          @(RTUploadVideoErrorUnknownReel),
                                      
                                      @"[thumbnail] is required":
                                          @(RTUploadVideoErrorMissingThumbnail),
                                      @"[thumbnail] must be png format":
                                          @(RTUploadVideoErrorInvalidThumbnail),
                                      @"[thumbnail] format is invalid":
                                          @(RTUploadVideoErrorInvalidThumbnail),
                                      @"[thumbnail] exceeds max size":
                                          @(RTUploadVideoErrorInvalidThumbnail),
                                      @"[thumbnail] size is invalid":
                                          @(RTUploadVideoErrorInvalidThumbnail),
                                      
                                      @"[video] is required":
                                          @(RTUploadVideoErrorMissingVideo),
                                      @"[video] must contain an h264 video stream":
                                          @(RTUploadVideoErrorInvalidVideo),
                                      @"Problem occurred while processing h264 video stream":
                                          @(RTUploadVideoErrorInvalidVideo),
                                      @"[video] must contain an aac audio stream":
                                          @(RTUploadVideoErrorInvalidVideo),
                                      @"Problem occurred while processing aac audio stream":
                                          @(RTUploadVideoErrorInvalidVideo),
                                      @"[video] exceeds max length of 2 minutes":
                                          @(RTUploadVideoErrorInvalidVideo),
                                      @"[video] duration is invalid":
                                          @(RTUploadVideoErrorInvalidVideo),
                                      @"[video] exceeds max size":
                                          @(RTUploadVideoErrorInvalidVideo),
                                      @"[video] size is invalid":
                                          @(RTUploadVideoErrorInvalidVideo)
                                      };
            
            [helper expectForServerMessageToErrorCodeMapping:mapping];
            [videoUploadFailure expectCallbackExecuted];
        });
    });
});

SpecEnd