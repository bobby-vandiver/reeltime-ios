#import "RTTestCommon.h"
#import "RTServerErrorMessageToErrorCodeTestHelper.h"

#import "RTDeleteReelDataManager.h"
#import "RTAPIClient.h"

#import "RTServerErrors.h"
#import "RTDeleteReelError.h"

SpecBegin(RTDeleteReelDataManager)

describe(@"delete reel data manager", ^{
    
    __block RTDeleteReelDataManager *dataManager;
    __block RTAPIClient *client;
    
    beforeEach(^{
        client = mock([RTAPIClient class]);
        dataManager = [[RTDeleteReelDataManager alloc] initWithClient:client];
    });
    
    describe(@"deleting a reel", ^{
        __block RTCallbackTestExpectation *deleted;
        __block RTCallbackTestExpectation *notDeleted;
        
        __block MKTArgumentCaptor *successCaptor;
        __block MKTArgumentCaptor *failureCaptor;
        
        beforeEach(^{
            deleted = [RTCallbackTestExpectation noArgsCallbackTestExpectation];
            notDeleted = [RTCallbackTestExpectation argsCallbackTextExpectation];
            
            successCaptor = [[MKTArgumentCaptor alloc] init];
            failureCaptor = [[MKTArgumentCaptor alloc] init];
            
            [dataManager deleteReelWithReelId:reelId
                                      success:deleted.noArgsCallback
                                      failure:notDeleted.argsCallback];
            
            [verify(client) deleteReelForReelId:reelId
                                        success:[successCaptor capture]
                                        failure:[failureCaptor capture]];
            
            [deleted expectCallbackNotExecuted];
            [notDeleted expectCallbackNotExecuted];
        });
        
        context(@"successful deletion", ^{
            it(@"should invoke deleted callback on success", ^{
                NoArgsCallback successHandler = [successCaptor value];
                successHandler();
                [deleted expectCallbackExecuted];
            });
        });
        
        context(@"deletion failed", ^{
            __block RTServerErrorMessageToErrorCodeTestHelper *helper;
            
            beforeEach(^{
                ServerErrorsCallback failureHandler = [failureCaptor value];
                
                id (^errorRetrievalBlock)() = ^{
                    return notDeleted.callbackArguments;
                };
                
                helper = [[RTServerErrorMessageToErrorCodeTestHelper alloc] initForErrorDomain:RTDeleteReelErrorDomain
                                                                            withFailureHandler:failureHandler
                                                                           errorRetrievalBlock:errorRetrievalBlock];
            });
            
            it(@"should map server errors to domain specific errors", ^{
                NSDictionary *mapping = @{
                                          @"Requested reel was not found":
                                              @(RTDeleteReelErrorReelNotFound),
                                          @"Unauthorized operation requested":
                                              @(RTDeleteReelErrorUnauthorized),
                                          @"uh oh":
                                              @(RTDeleteReelErrorUnknownError)
                                          };
                
                [helper expectForServerMessageToErrorCodeMapping:mapping];
                [notDeleted expectCallbackExecuted];
            });
        });
    });
});

SpecEnd
