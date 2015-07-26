#import "RTTestCommon.h"

#import "RTBrowseUserFolloweesDataManagerDelegate.h"

SpecBegin(RTBrowseUserFolloweesDataManagerDelegate)

describe(@"browse user followees data manager delegate", ^{
    
    __block RTBrowseUserFolloweesDataManagerDelegate *delegate;

    __block RTAPIClient *client;
    
    beforeEach(^{
        client = mock([RTAPIClient class]);
        delegate = [[RTBrowseUserFolloweesDataManagerDelegate alloc] initWithUsername:username];
    });
    
    it(@"should list followees for user", ^{
        RTCallbackTestExpectation *followeesListRetrieved = [RTCallbackTestExpectation argsCallbackTextExpectation];
        RTCallbackTestExpectation *serverErrorsOccurred = [RTCallbackTestExpectation argsCallbackTextExpectation];
        
        [delegate listUsersPage:pageNumber
                     withClient:client
                        success:followeesListRetrieved.argsCallback
                        failure:serverErrorsOccurred.argsCallback];
        
        MKTArgumentCaptor *successCaptor = [[MKTArgumentCaptor alloc] init];
        MKTArgumentCaptor *failureCaptor = [[MKTArgumentCaptor alloc] init];
        
        [verify(client) listFolloweesPage:pageNumber
                      forUserWithUsername:username
                                  success:[successCaptor capture]
                                  failure:[failureCaptor capture]];
        
        [followeesListRetrieved expectCallbackNotExecuted];
        
        UserListCallback capturedSuccessCallback = [successCaptor value];
        capturedSuccessCallback(nil);
        
        [followeesListRetrieved expectCallbackExecuted];
        
        [serverErrorsOccurred expectCallbackNotExecuted];
        
        ServerErrorsCallback capturedFailureCallback = [failureCaptor value];
        capturedFailureCallback(nil);
        
        [serverErrorsOccurred expectCallbackExecuted];
    });
});

SpecEnd
