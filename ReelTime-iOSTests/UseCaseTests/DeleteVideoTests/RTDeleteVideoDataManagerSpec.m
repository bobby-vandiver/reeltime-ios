#import "RTTestCommon.h"
#import "RTServerErrorMessageToErrorCodeTestHelper.h"

#import "RTDeleteVideoDataManager.h"
#import "RTAPIClient.h"

#import "RTServerErrors.h"
#import "RTDeleteVideoError.h"

SpecBegin(RTDeleteVideoDataManager)

describe(@"delete video data manager", ^{
    
    __block RTDeleteVideoDataManager *dataManager;
    __block RTAPIClient *client;
    
    beforeEach(^{
        client = mock([RTAPIClient class]);
        dataManager = [[RTDeleteVideoDataManager alloc] initWithClient:client];
    });
    
    describe(@"delete a video", ^{
        __block RTCallbackTestExpectation *deleted;
        __block RTCallbackTestExpectation *notDeleted;
        
        __block MKTArgumentCaptor *successCaptor;
        __block MKTArgumentCaptor *failureCaptor;
        
        beforeEach(^{
            deleted = [RTCallbackTestExpectation noArgsCallbackTestExpectation];
            notDeleted = [RTCallbackTestExpectation argsCallbackTextExpectation];
            
            successCaptor = [[MKTArgumentCaptor alloc] init];
            failureCaptor = [[MKTArgumentCaptor alloc] init];
            
            [dataManager deleteVideoForVideoId:videoId
                                       success:deleted.noArgsCallback
                                       failure:notDeleted.argsCallback];
            
            [verify(client) deleteVideoForVideoId:videoId
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
        
        context(@"failed to delete", ^{
            __block RTServerErrorMessageToErrorCodeTestHelper *helper;
            
            beforeEach(^{
                ServerErrorsCallback failureHandler = [failureCaptor value];
                
                id (^errorRetrievalBlock)() = ^{
                    return notDeleted.callbackArguments;
                };
                
                helper = [[RTServerErrorMessageToErrorCodeTestHelper alloc] initForErrorDomain:RTDeleteVideoErrorDomain
                                                                            withFailureHandler:failureHandler
                                                                           errorRetrievalBlock:errorRetrievalBlock];
            });
            
            it(@"should map server errors to domain specific errors", ^{
                NSDictionary *mapping = @{
                                          @"Requested video was not found":
                                              @(RTDeleteVideoErrorVideoNotFound),
                                          @"uh oh":
                                              @(RTDeleteVideoErrorUnknownError)
                                          };
                
                [helper expectForServerMessageToErrorCodeMapping:mapping];
                [notDeleted expectCallbackExecuted];
            });
        });
    });
});

SpecEnd
