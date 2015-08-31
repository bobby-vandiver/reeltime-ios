#import "RTTestCommon.h"
#import "RTServerErrorMessageToErrorCodeTestHelper.h"

#import "RTJoinAudienceDataManager.h"
#import "RTAPIClient.h"

#import "RTServerErrors.h"
#import "RTJoinAudienceError.h"

SpecBegin(RTJoinAudienceDataManager)

describe(@"join audience data manager", ^{
    
    __block RTJoinAudienceDataManager *dataManager;
    __block RTAPIClient *client;

    beforeEach(^{
        client = mock([RTAPIClient class]);
        dataManager = [[RTJoinAudienceDataManager alloc] initWithClient:client];
    });
    
    describe(@"joining audience", ^{
        __block RTCallbackTestExpectation *joined;
        __block RTCallbackTestExpectation *notJoined;
        
        __block MKTArgumentCaptor *successCaptor;
        __block MKTArgumentCaptor *failureCaptor;
        
        beforeEach(^{
            joined = [RTCallbackTestExpectation noArgsCallbackTestExpectation];
            notJoined = [RTCallbackTestExpectation argsCallbackTextExpectation];
            
            successCaptor = [[MKTArgumentCaptor alloc] init];
            failureCaptor = [[MKTArgumentCaptor alloc] init];

            [dataManager requestAudienceMembershipForReelId:@(reelId)
                                                joinSuccess:joined.noArgsCallback
                                                joinFailure:notJoined.argsCallback];

            [verify(client) joinAudienceForReelWithReelId:reelId
                                                  success:[successCaptor capture]
                                                  failure:[failureCaptor capture]];
            
            [joined expectCallbackNotExecuted];
            [notJoined expectCallbackNotExecuted];
        });
        
        
        context(@"successful join", ^{
            it(@"should invoke joined callback on success", ^{
                NoArgsCallback successHandler = [successCaptor value];
                successHandler();
                [joined expectCallbackExecuted];
            });
        });

        context(@"failed to join", ^{
            __block RTServerErrorMessageToErrorCodeTestHelper *helper;

            beforeEach(^{
                ServerErrorsCallback failureHander = [failureCaptor value];
                
                id (^errorRetrievalBlock)() = ^{
                    return notJoined.callbackArguments;
                };
                
                helper = [[RTServerErrorMessageToErrorCodeTestHelper alloc] initForErrorDomain:RTJoinAudienceErrorDomain
                                                                            withFailureHandler:failureHander
                                                                           errorRetrievalBlock:errorRetrievalBlock];
            });
            
            it(@"should map server errors to domain specific errors", ^{
                NSDictionary *mapping = @{
                                          @"Requested reel was not found":
                                              @(RTJoinAudienceErrorReelNotFound),
                                          @"uh oh":
                                              @(RTJoinAudienceErrorUnknownError)
                                          };
                
                [helper expectForServerMessageToErrorCodeMapping:mapping];
                [notJoined expectCallbackExecuted];
            });
        });
    });
});

SpecEnd