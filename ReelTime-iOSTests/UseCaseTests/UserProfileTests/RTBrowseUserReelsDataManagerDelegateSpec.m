#import "RTTestCommon.h"

#import "RTBrowseUserReelsDataManagerDelegate.h"

SpecBegin(RTBrowseUserReelsDataManagerDelegate)

describe(@"browse user reels data manager delegate", ^{
    
    __block RTBrowseUserReelsDataManagerDelegate *delegate;
    
    __block RTClient *client;
    
    beforeEach(^{
        client = mock([RTClient class]);
        delegate = [[RTBrowseUserReelsDataManagerDelegate alloc] initWithUsername:username];
    });
    
    it(@"should list the user's reels", ^{
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
                  forUserWithUsername:username
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