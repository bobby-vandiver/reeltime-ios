#import "RTTestCommon.h"
#import "RTServerErrorMessageToErrorCodeTestHelper.h"

#import "RTLeaveAudienceDataManager.h"
#import "RTAPIClient.h"

#import "RTLeaveAudienceError.h"
#import "RTServerErrors.h"

SpecBegin(RTLeaveAudienceDataManager)

describe(@"leave audience data manager", ^{
    
    __block RTLeaveAudienceDataManager *dataManager;
    __block RTAPIClient *client;
    
    beforeEach(^{
        client = mock([RTAPIClient class]);
        dataManager = [[RTLeaveAudienceDataManager alloc] initWithClient:client];
    });
    
    describe(@"leaving audience", ^{
        __block RTCallbackTestExpectation *left;
        __block RTCallbackTestExpectation *notLeft;
        
        __block MKTArgumentCaptor *successCaptor;
        __block MKTArgumentCaptor *failureCaptor;
        
        beforeEach(^{
            left = [RTCallbackTestExpectation noArgsCallbackTestExpectation];
            notLeft = [RTCallbackTestExpectation argsCallbackTextExpectation];
            
            successCaptor = [[MKTArgumentCaptor alloc] init];
            failureCaptor = [[MKTArgumentCaptor alloc] init];
            
            [dataManager requestAudienceLeaveForReelId:@(reelId)
                                          leaveSuccess:left.noArgsCallback
                                          leaveFailure:notLeft.argsCallback];
            
            [verify(client) leaveAudienceForReelWithReelId:reelId
                                                   success:[successCaptor capture]
                                                   failure:[failureCaptor capture]];
        });
        
        context(@"successful leave", ^{
            it(@"should invoke left callback on success", ^{
                NoArgsCallback successHandler = [successCaptor value];
                successHandler();
                [left expectCallbackExecuted];
            });
        });
        
        context(@"failed to leave", ^{
            __block RTServerErrorMessageToErrorCodeTestHelper *helper;

            beforeEach(^{
                ServerErrorsCallback failureHandler = [failureCaptor value];
                
                id (^errorRetrievalBlock)() = ^{
                    return notLeft.callbackArguments;
                };
                
                helper = [[RTServerErrorMessageToErrorCodeTestHelper alloc] initForErrorDomain:RTLeaveAudienceErrorDomain
                                                                            withFailureHandler:failureHandler
                                                                           errorRetrievalBlock:errorRetrievalBlock];
            });
            
            it(@"should map server errors to domain specific errors", ^{
                NSDictionary *mapping = @{
                                          @"Requested reel was not found":
                                              @(RTLeaveAudienceErrorReelNotFound),
                                          @"uh oh":
                                              @(RTLeaveAudienceErrorUnknownError)
                                          };
                
                [helper expectForServerMessageToErrorCodeMapping:mapping];
                [notLeft expectCallbackExecuted];
            });
        });
    });
});

SpecEnd
