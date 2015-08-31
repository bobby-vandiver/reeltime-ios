#import "RTTestCommon.h"
#import "RTServerErrorMessageToErrorCodeTestHelper.h"

#import "RTAddVideoToReelDataManager.h"
#import "RTAPIClient.h"

#import "RTServerErrors.h"
#import "RTAddVideoToReelError.h"

SpecBegin(RTAddVideoToReelDataManager)

describe(@"add video to reel data manager", ^{
    
    __block RTAddVideoToReelDataManager *dataManager;
    __block RTAPIClient *client;
    
    beforeEach(^{
        client = mock([RTAPIClient class]);
        dataManager = [[RTAddVideoToReelDataManager alloc] initWithClient:client];
    });
    
    describe(@"add video to reel", ^{
        __block RTCallbackTestExpectation *added;
        __block RTCallbackTestExpectation *notAdded;
        
        __block MKTArgumentCaptor *successCaptor;
        __block MKTArgumentCaptor *failureCaptor;
        
        beforeEach(^{
            added = [RTCallbackTestExpectation noArgsCallbackTestExpectation];
            notAdded = [RTCallbackTestExpectation argsCallbackTextExpectation];
            
            successCaptor = [[MKTArgumentCaptor alloc] init];
            failureCaptor = [[MKTArgumentCaptor alloc] init];
            
            [dataManager addVideoForVideoId:videoId
                            toReelForReelId:reelId
                                    success:added.noArgsCallback
                                    failure:notAdded.argsCallback];
            
            [verify(client) addVideoWithVideoId:videoId
                               toReelWithReelId:reelId
                                        success:[successCaptor capture]
                                        failure:[failureCaptor capture]];
            
            [added expectCallbackNotExecuted];
            [notAdded expectCallbackNotExecuted];
        });
        
        context(@"successful addition", ^{
            it(@"should invoke added callback on success", ^{
                NoArgsCallback successHandler = [successCaptor value];
                successHandler();
                [added expectCallbackExecuted];
            });
        });
        
        context(@"failed to add", ^{
            __block RTServerErrorMessageToErrorCodeTestHelper *helper;

            beforeEach(^{
                ServerErrorsCallback failureHandler = [failureCaptor value];
                
                id (^errorRetrievalBlock)() = ^{
                    return notAdded.callbackArguments;
                };
                
                helper = [[RTServerErrorMessageToErrorCodeTestHelper alloc] initForErrorDomain:RTAddVideoToReelErrorDomain
                                                                            withFailureHandler:failureHandler
                                                                           errorRetrievalBlock:errorRetrievalBlock];
            });
            
            it(@"should map server errors to domain specific errors", ^{
                NSDictionary *mapping = @{
                                          @"Requested video was not found":
                                              @(RTAddVideoToReelErrorVideoNotFound),
                                          @"Requested reel was not found":
                                              @(RTAddVideoToReelErrorReelNotFound),
                                          @"Unauthorized operation requested":
                                              @(RTAddVideoToReelErrorUnauthorized),
                                          @"uh oh":
                                              @(RTAddVideoToReelErrorUnknownError)
                                          };
                
                [helper expectForServerMessageToErrorCodeMapping:mapping];
                [notAdded expectCallbackExecuted];
            });
        });
    });
});

SpecEnd
