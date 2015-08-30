#import "RTTestCommon.h"

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
            it(@"video not found", ^{
                RTServerErrors *serverErrors = [[RTServerErrors alloc] init];
                serverErrors.errors = @[@"Requested video was not found"];
                
                ServerErrorsCallback failureHandler = [failureCaptor value];
                failureHandler(serverErrors);
                
                [notAdded expectCallbackExecuted];
                expect(notAdded.callbackArguments).to.beError(RTAddVideoToReelErrorDomain,
                                                              RTAddVideoToReelErrorVideoNotFound);
            });
            
            it(@"reel not found", ^{
                RTServerErrors *serverErrors = [[RTServerErrors alloc] init];
                serverErrors.errors = @[@"Requested reel was not found"];
                
                ServerErrorsCallback failureHandler = [failureCaptor value];
                failureHandler(serverErrors);
                
                [notAdded expectCallbackExecuted];
                expect(notAdded.callbackArguments).to.beError(RTAddVideoToReelErrorDomain,
                                                              RTAddVideoToReelErrorReelNotFound);
            });
            
            it(@"unauthorized request", ^{
                RTServerErrors *serverErrors = [[RTServerErrors alloc] init];
                serverErrors.errors = @[@"Unauthorized operation requested"];
                
                ServerErrorsCallback failureHandler = [failureCaptor value];
                failureHandler(serverErrors);
                
                [notAdded expectCallbackExecuted];
                expect(notAdded.callbackArguments).to.beError(RTAddVideoToReelErrorDomain,
                                                              RTAddVideoToReelErrorUnauthorized);
            });
            
            it(@"unknown error", ^{
                RTServerErrors *serverErrors = [[RTServerErrors alloc] init];
                serverErrors.errors = @[@"uh oh"];
                
                ServerErrorsCallback failureHandler = [failureCaptor value];
                failureHandler(serverErrors);
                
                [notAdded expectCallbackExecuted];
                expect(notAdded.callbackArguments).to.beError(RTAddVideoToReelErrorDomain,
                                                              RTAddVideoToReelErrorUnknownError);
            });
        });
    });
});

SpecEnd
