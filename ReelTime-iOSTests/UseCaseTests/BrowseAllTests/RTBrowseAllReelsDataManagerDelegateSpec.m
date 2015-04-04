#import "RTTestCommon.h"

#import "RTBrowseAllReelsDataManagerDelegate.h"

SpecBegin(RTBrowseAllReelsDataManagerDelegate)

describe(@"browse all reels data manager delegate", ^{
    
    __block RTBrowseAllReelsDataManagerDelegate *delegate;
    
    __block RTClient *client;
    
    beforeEach(^{
        client = mock([RTClient class]);
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
        
        NSUInteger page = 1234;
        [delegate listReelsPage:page
                     withClient:client
                        success:successCallback
                        failure:failureCallback];

        MKTArgumentCaptor *successCaptor = [[MKTArgumentCaptor alloc] init];
        MKTArgumentCaptor *failureCaptor = [[MKTArgumentCaptor alloc] init];
        
        [verify(client) listReelsPage:page
                              success:[successCaptor capture]
                              failure:[failureCaptor capture]];
        
        expect(successCalled).to.beFalsy();
        
        ReelListCallback capturedSuccessCallback = [successCaptor value];
        capturedSuccessCallback(nil);
        
        expect(successCalled).to.beTruthy();
        
        expect(failureCalled).to.beFalsy();
        
        ServerErrorsCallback capturedFailuredCallback = [failureCaptor value];
        capturedFailuredCallback(nil);
        
        expect(failureCalled).to.beTruthy();
    });
});

SpecEnd
