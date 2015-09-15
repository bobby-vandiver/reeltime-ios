#import "RTTestCommon.h"
#import "RTServerErrorMessageToErrorCodeTestHelper.h"

#import "RTRemoveVideoFromReelDataManager.h"
#import "RTAPIClient.h"

#import "RTServerErrors.h"
#import "RTRemoveVideoFromReelError.h"

SpecBegin(RTRemoveVideoFromReelDataManager)

describe(@"remove video from reel data manager", ^{
    
    __block RTRemoveVideoFromReelDataManager *dataManager;
    __block RTAPIClient *client;
    
    beforeEach(^{
        client = mock([RTAPIClient class]);
        dataManager = [[RTRemoveVideoFromReelDataManager alloc] initWithClient:client];
    });
    
    describe(@"remove a video", ^{
        __block RTCallbackTestExpectation *removed;
        __block RTCallbackTestExpectation *notRemoved;
        
        __block MKTArgumentCaptor *successCaptor;
        __block MKTArgumentCaptor *failureCaptor;
        
        beforeEach(^{
            removed = [RTCallbackTestExpectation noArgsCallbackTestExpectation];
            notRemoved = [RTCallbackTestExpectation argsCallbackTextExpectation];
            
            successCaptor = [[MKTArgumentCaptor alloc] init];
            failureCaptor = [[MKTArgumentCaptor alloc] init];
            
            [dataManager removeVideoForVideoId:videoId
                             fromReelForReelId:reelId
                                       success:removed.noArgsCallback
                                       failure:notRemoved.argsCallback];
            
            [verify(client) removeVideoWithVideoId:videoId
                                fromReelWithReelId:reelId
                                           success:[successCaptor capture]
                                           failure:[failureCaptor capture]];
            
            [removed expectCallbackNotExecuted];
            [notRemoved expectCallbackNotExecuted];
        });
        
        context(@"successful removal", ^{
            it(@"should invoke removed callback on success", ^{
                NoArgsCallback successHandler = [successCaptor value];
                successHandler();
                [removed expectCallbackExecuted];
            });
        });
        
        context(@"failed to remove", ^{
            __block RTServerErrorMessageToErrorCodeTestHelper *helper;
            
            beforeEach(^{
                ServerErrorsCallback failureHandler = [failureCaptor value];
                
                id (^errorRetrievalBlock)() = ^{
                    return notRemoved.callbackArguments;
                };
                
                helper = [[RTServerErrorMessageToErrorCodeTestHelper alloc] initForErrorDomain:RTRemoveVideoFromReelErrorDomain
                                                                            withFailureHandler:failureHandler
                                                                           errorRetrievalBlock:errorRetrievalBlock];
            });
            
            it(@"should map server errors to domain specific errors", ^{
                NSDictionary *mapping = @{
                                          @"Requested video was not found":
                                              @(RTRemoveVideoFromReelErrorVideoNotFound),
                                          @"Requested reel was not found":
                                              @(RTRemoveVideoFromReelErrorReelNotFound),
                                          @"Unauthorized operation requested":
                                              @(RTRemoveVideoFromReelErrorUnauthorized),
                                          @"uh oh":
                                              @(RTRemoveVideoFromReelErrorUnknownError)
                                          };

                [helper expectForServerMessageToErrorCodeMapping:mapping];
                [notRemoved expectCallbackExecuted];
            });
        });
    });
});

SpecEnd