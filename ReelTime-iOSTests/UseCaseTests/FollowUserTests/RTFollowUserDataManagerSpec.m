#import "RTTestCommon.h"
#import "RTServerErrorMessageToErrorCodeTestHelper.h"

#import "RTFollowUserDataManager.h"
#import "RTAPIClient.h"

#import "RTServerErrors.h"
#import "RTFollowUserError.h"

SpecBegin(RTFollowUserDataManager)

describe(@"follow user data manager", ^{
    
    __block RTFollowUserDataManager *dataManager;
    __block RTAPIClient *client;
    
    beforeEach(^{
        client = mock([RTAPIClient class]);
        dataManager = [[RTFollowUserDataManager alloc] initWithClient:client];
    });
    
    describe(@"following a user", ^{
        __block RTCallbackTestExpectation *followed;
        __block RTCallbackTestExpectation *notFollowed;
        
        __block MKTArgumentCaptor *successCaptor;
        __block MKTArgumentCaptor *failureCaptor;
        
        beforeEach(^{
            followed = [RTCallbackTestExpectation noArgsCallbackTestExpectation];
            notFollowed = [RTCallbackTestExpectation argsCallbackTextExpectation];
            
            successCaptor = [[MKTArgumentCaptor alloc] init];
            failureCaptor = [[MKTArgumentCaptor alloc] init];
            
            [dataManager followUserWithUsername:username
                                  followSuccess:followed.noArgsCallback
                                  followFailure:notFollowed.argsCallback];
            
            [verify(client) followUserForUsername:username
                                          success:[successCaptor capture]
                                          failure:[failureCaptor capture]];
            
            [followed expectCallbackNotExecuted];
            [notFollowed expectCallbackNotExecuted];
        });
        
        context(@"successful follow", ^{
            it(@"should invoke followed callback on success", ^{
                NoArgsCallback successHandler = [successCaptor value];
                successHandler();
                [followed expectCallbackExecuted];
            });
        });
        
        context(@"failed to follow", ^{
            __block RTServerErrorMessageToErrorCodeTestHelper *helper;

            beforeEach(^{
                ServerErrorsCallback failureHandler = [failureCaptor value];
                
                id (^errorRetrievalBlock)() = ^{
                    return notFollowed.callbackArguments;
                };
                
                helper = [[RTServerErrorMessageToErrorCodeTestHelper alloc] initForErrorDomain:RTFollowUserErrorDomain
                                                                            withFailureHandler:failureHandler
                                                                           errorRetrievalBlock:errorRetrievalBlock];
            });
            
            it(@"user not found", ^{
                RTServerErrors *serverErrors = [[RTServerErrors alloc] init];
                serverErrors.errors = @[@"Requested user was not found"];
                
                ServerErrorsCallback failureHandler= [failureCaptor value];
                failureHandler(serverErrors);
                
                [notFollowed expectCallbackExecuted];
                expect(notFollowed.callbackArguments).to.beError(RTFollowUserErrorDomain,
                                                                 RTFollowUserErrorUserNotFound);
            });
            
            it(@"unknown error", ^{
                RTServerErrors *serverErrors = [[RTServerErrors alloc] init];
                serverErrors.errors = @[@"uh oh"];
                
                ServerErrorsCallback failureHandler = [failureCaptor value];
                failureHandler(serverErrors);
                
                [notFollowed expectCallbackExecuted];
                expect(notFollowed.callbackArguments).to.beError(RTFollowUserErrorDomain,
                                                                 RTFollowUserErrorUnknownError);
            });
            
            it(@"should map server errors to domain specific errors", ^{
                NSDictionary *mapping = @{
                                          @"Requested user was not found":
                                              @(RTFollowUserErrorUserNotFound),
                                          @"uh oh":
                                              @(RTFollowUserErrorUnknownError)
                                          };
                
                [helper expectForServerMessageToErrorCodeMapping:mapping];
                [notFollowed expectCallbackExecuted];
            });
        });
    });
});

SpecEnd