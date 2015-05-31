#import "RTTestCommon.h"

#import "RTBrowseReelVideosDataManagerDelegate.h"

SpecBegin(RTBrowseReelVideosDataManagerDelegate)

describe(@"browse reel videos data manager delegate", ^{
    
    __block RTBrowseReelVideosDataManagerDelegate *delegate;
    
    __block RTAPIClient *client;
    
    beforeEach(^{
        client = mock([RTAPIClient class]);
        delegate = [[RTBrowseReelVideosDataManagerDelegate alloc] initWithReelId:@(reelId)];
    });
    
    it(@"should list videos in the reel", ^{
        __block BOOL successCalled = NO;
        VideoListCallback successCallback = ^(RTVideoList *videoList) {
            successCalled = YES;
        };
        
        __block BOOL failureCalled = NO;
        ServerErrorsCallback failureCallback = ^(RTServerErrors *serverErrors) {
            failureCalled = YES;
        };
        
        [delegate listVideosPage:pageNumber
                      withClient:client
                         success:successCallback
                         failure:failureCallback];
        
        MKTArgumentCaptor *successCaptor = [[MKTArgumentCaptor alloc] init];
        MKTArgumentCaptor *failureCaptor = [[MKTArgumentCaptor alloc] init];

        [verify(client) listVideosPage:pageNumber
                     forReelWithReelId:reelId
                               success:[successCaptor capture]
                               failure:[failureCaptor capture]];
        
        expect(successCalled).to.beFalsy();
        
        VideoListCallback capturedSuccessCallback = [successCaptor value];
        capturedSuccessCallback(nil);
        
        expect(successCalled).to.beTruthy();
        
        expect(failureCalled).to.beFalsy();
        
        ServerErrorsCallback capturedFailureCallback = [failureCaptor value];
        capturedFailureCallback(nil);
        
        expect(failureCalled).to.beTruthy();

    });
});

SpecEnd