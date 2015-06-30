#import "RTTestCommon.h"

#import "RTBrowseAudienceMembersDataManagerDelegate.h"

SpecBegin(RTBrowseAudienceMembersDataManagerDelegate)

describe(@"browse audience members data manager delegate", ^{
    
    __block RTBrowseAudienceMembersDataManagerDelegate *delegate;
    
    __block RTAPIClient *client;
    
    beforeEach(^{
        client = mock([RTAPIClient class]);
        delegate = [[RTBrowseAudienceMembersDataManagerDelegate alloc] initWithReelId:@(reelId)];
    });
    
    it(@"should list audience members for reel", ^{
        RTCallbackTestExpectation *membersListRetrieved = [RTCallbackTestExpectation argsCallbackTextExpectation];
        RTCallbackTestExpectation *serverErrorsOccurred = [RTCallbackTestExpectation argsCallbackTextExpectation];
        
        [delegate listUsersPage:pageNumber
                     withClient:client
                        success:membersListRetrieved.argsCallback
                        failure:serverErrorsOccurred.argsCallback];
        
        MKTArgumentCaptor *successCaptor = [[MKTArgumentCaptor alloc] init];
        MKTArgumentCaptor *failureCaptor = [[MKTArgumentCaptor alloc] init];
        
        [verify(client) listAudienceMembersPage:pageNumber
                              forReelWithReelId:reelId
                                        success:[successCaptor capture]
                                        failure:[failureCaptor capture]];
        
        [membersListRetrieved expectCallbackNotExecuted];
        
        UserListCallback capturedSuccessCallback = [successCaptor value];
        capturedSuccessCallback(nil);
        
        [membersListRetrieved expectCallbackExecuted];

        [serverErrorsOccurred expectCallbackNotExecuted];
        
        ServerErrorsCallback capturedFailureCallback = [failureCaptor value];
        capturedFailureCallback(nil);
        
        [serverErrorsOccurred expectCallbackExecuted];
    });
});

SpecEnd