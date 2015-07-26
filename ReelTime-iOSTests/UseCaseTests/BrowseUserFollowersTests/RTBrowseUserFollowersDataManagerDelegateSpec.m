#import "RTTestCommon.h"

#import "RTBrowseUserFollowersDataManagerDelegate.h"

SpecBegin(RTBrowseUserFollowersDataManagerDelegate)

describe(@"browse user followers data manager delegate", ^{
    
    __block RTBrowseUserFollowersDataManagerDelegate *delegate;
    
    __block RTAPIClient *client;
    
    beforeEach(^{
        client = mock([RTAPIClient class]);
        delegate = [[RTBrowseUserFollowersDataManagerDelegate alloc] initWithUsername:username];
    });
    
    it(@"should list followers for user", ^{
        RTCallbackTestExpectation *followersListRetrieved = [RTCallbackTestExpectation argsCallbackTextExpectation];
        RTCallbackTestExpectation *serverErrorsOccurred = [RTCallbackTestExpectation argsCallbackTextExpectation];
        
        [delegate listUsersPage:pageNumber
                     withClient:client
                        success:followersListRetrieved.argsCallback
                        failure:serverErrorsOccurred.argsCallback];
        
        MKTArgumentCaptor *successCaptor = [[MKTArgumentCaptor alloc] init];
        MKTArgumentCaptor *failureCaptor = [[MKTArgumentCaptor alloc] init];
        
        [verify(client) listFollowersPage:pageNumber
                      forUserWithUsername:username
                                  success:[successCaptor capture]
                                  failure:[failureCaptor capture]];
        
        [followersListRetrieved expectCallbackNotExecuted];
        
        UserListCallback capturedSuccessCallback = [successCaptor value];
        capturedSuccessCallback(nil);
        
        [followersListRetrieved expectCallbackExecuted];
        
        [serverErrorsOccurred expectCallbackNotExecuted];
        
        ServerErrorsCallback capturedFailureCallback = [failureCaptor value];
        capturedFailureCallback(nil);
        
        [serverErrorsOccurred expectCallbackExecuted];
    });
});

SpecEnd
