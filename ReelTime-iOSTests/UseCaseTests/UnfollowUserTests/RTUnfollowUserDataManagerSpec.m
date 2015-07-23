#import "RTTestCommon.h"

#import "RTUnfollowUserDataManager.h"
#import "RTAPIClient.h"

#import "RTServerErrors.h"
#import "RTUnfollowUserError.h"

SpecBegin(RTUnfollowUserDataManager)

describe(@"unfollow user data manager", ^{
    
    __block RTUnfollowUserDataManager *dataManager;
    __block RTAPIClient *client;
    
    beforeEach(^{
        client = mock([RTAPIClient class]);
        dataManager = [[RTUnfollowUserDataManager alloc] initWithClient:client];
    });
    
    describe(@"unfollowing a user", ^{
        __block RTCallbackTestExpectation *unfollowed;
        __block RTCallbackTestExpectation *notUnfollowed;
        
        __block MKTArgumentCaptor *successCaptor;
        __block MKTArgumentCaptor *failureCaptor;
        
        beforeEach(^{
            unfollowed = [RTCallbackTestExpectation noArgsCallbackTestExpectation];
            notUnfollowed = [RTCallbackTestExpectation argsCallbackTextExpectation];
            
            successCaptor = [[MKTArgumentCaptor alloc] init];
            failureCaptor = [[MKTArgumentCaptor alloc] init];
            
            [dataManager unfollowUserWithUsername:username
                                  unfollowSuccess:unfollowed.noArgsCallback
                                  unfollowFailure:notUnfollowed.argsCallback];
            
            [verify(client) unfollowUserForUsername:username
                                            success:[successCaptor capture]
                                            failure:[failureCaptor capture]];
            
            [unfollowed expectCallbackNotExecuted];
            [notUnfollowed expectCallbackNotExecuted];
        });
        
        context(@"successful unfollow", ^{
            it(@"should invoke unfollowed callback on success", ^{
                NoArgsCallback successHandler = [successCaptor value];
                successHandler();
                [unfollowed expectCallbackExecuted];
            });
        });
        
        context(@"failed to unfollow", ^{
            it(@"user not found", ^{
                RTServerErrors *serverErrors = [[RTServerErrors alloc] init];
                serverErrors.errors = @[@"Requested user was not found"];
                
                ServerErrorsCallback failureHandler= [failureCaptor value];
                failureHandler(serverErrors);
                
                [notUnfollowed expectCallbackExecuted];
                expect(notUnfollowed.callbackArguments).to.beError(RTUnfollowUserErrorDomain,
                                                                   RTUnfollowUserErrorUserNotFound);
            });
            
            it(@"unknown error", ^{
                RTServerErrors *serverErrors = [[RTServerErrors alloc] init];
                serverErrors.errors = @[@"uh oh"];
                
                ServerErrorsCallback failureHandler = [failureCaptor value];
                failureHandler(serverErrors);
                
                [notUnfollowed expectCallbackExecuted];
                expect(notUnfollowed.callbackArguments).to.beError(RTUnfollowUserErrorDomain,
                                                                   RTUnfollowUserErrorUnknownError);
            });
        });
    });
});

SpecEnd