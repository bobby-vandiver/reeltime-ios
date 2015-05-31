#import "RTTestCommon.h"

#import "RTBrowseAllUsersDataManagerDelegate.h"

SpecBegin(RTBrowseAllUsersDataManagerDelegate)

describe(@"browse all users data manager delegate", ^{
    
    __block RTBrowseAllUsersDataManagerDelegate *delegate;
    
    __block RTAPIClient *client;
    
    beforeEach(^{
        client = mock([RTAPIClient class]);
        delegate = [[RTBrowseAllUsersDataManagerDelegate alloc] init];
    });
    
    it(@"should list users", ^{
        __block BOOL successCalled = NO;
        UserListCallback successCallback = ^(RTUserList *userList) {
            successCalled = YES;
        };
        
        __block BOOL failureCalled = NO;
        ServerErrorsCallback failureCallback = ^(RTServerErrors *serverErrors) {
            failureCalled = YES;
        };
        
        [delegate listUsersPage:pageNumber
                     withClient:client
                        success:successCallback
                        failure:failureCallback];
        
        MKTArgumentCaptor *successCaptor = [[MKTArgumentCaptor alloc] init];
        MKTArgumentCaptor *failureCaptor = [[MKTArgumentCaptor alloc] init];
        
        [verify(client) listUsersPage:pageNumber
                              success:[successCaptor capture]
                              failure:[failureCaptor capture]];
        
        expect(successCalled).to.beFalsy();
        
        UserListCallback capturedSuccessCallback = [successCaptor value];
        capturedSuccessCallback(nil);
        
        expect(successCalled).to.beTruthy();
        
        expect(failureCalled).to.beFalsy();
        
        ServerErrorsCallback capturedFailureCallback = [failureCaptor value];
        capturedFailureCallback(nil);
        
        expect(failureCalled).to.beTruthy();
    });
});

SpecEnd