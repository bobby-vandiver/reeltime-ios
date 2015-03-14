#import "RTTestCommon.h"

#import "RTBrowseVideosDataManager.h"
#import "RTClient.h"

#import "RTVideo.h"
#import "RTVideoList.h"

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
                                                        title:@"some video"];

            RTVideoList *videoList = [[RTVideoList alloc] init];
            videoList.videos = @[video];
            
            MKTArgumentCaptor *successCaptor = [[MKTArgumentCaptor alloc] init];
            
            [verify(client) listVideosPage:pageNumber
                                   success:[successCaptor capture]
                                   failure:anything()];
            
            expect(callbackExecuted).to.beFalsy();
            
            VideoListCallback successHandler = [successCaptor value];
            successHandler(videoList);
            
            expect(callbackExecuted).to.beTruthy();
            
            expect(callbackVideos).toNot.beNil();
            expect(callbackVideos).to.haveCountOf(1);
            
            expect(callbackVideos[0]).to.beVideo(@(videoId), @"some video");
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