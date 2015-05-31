#import "RTTestCommon.h"

#import "RTBrowseAllReelsDataManagerDelegate.h"

SpecBegin(RTBrowseAllReelsDataManagerDelegate)

describe(@"browse all reels data manager delegate", ^{
    
    __block RTBrowseAllReelsDataManagerDelegate *delegate;
    
    __block RTAPIClient *client;
    
    beforeEach(^{
        client = mock([RTAPIClient class]);
        delegate = [[RTBrowseAllReelsDataManagerDelegate alloc] init];
    });
    
    it(@"should list reels", ^{
        __block BOOL successCalled = NO;
        ReelListCallback successCallback = ^(RTReelList *reelList) {
            successCalled = YES;
        };
        
        __block BOOL failureCalled = NO;
        ServerErrorsCallback failureCallback = ^(RTServerErrors *serverErrors) {
            failureCalled = YES;
        };
        
        [delegate listReelsPage:pageNumber
                     withClient:client
                        success:successCallback
                        failure:failureCallback];

        MKTArgumentCaptor *successCaptor = [[MKTArgumentCaptor alloc] init];
        MKTArgumentCaptor *failureCaptor = [[MKTArgumentCaptor alloc] init];
        
        [verify(client) listReelsPage:pageNumber
                              success:[successCaptor capture]
                              failure:[failureCaptor capture]];
        
        expect(successCalled).to.beFalsy();
        
        ReelListCallback capturedSuccessCallback = [successCaptor value];
        capturedSuccessCallback(nil);
        
        expect(successCalled).to.beTruthy();
        
        expect(failureCalled).to.beFalsy();
        
        ServerErrorsCallback capturedFailureCallback = [failureCaptor value];
        capturedFailureCallback(nil);
        
        expect(failureCalled).to.beTruthy();
    });
});

SpecEnd
