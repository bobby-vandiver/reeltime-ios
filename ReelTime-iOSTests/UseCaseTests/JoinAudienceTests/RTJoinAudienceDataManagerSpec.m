#import "RTTestCommon.h"

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
            it(@"reel not found", ^{
                RTServerErrors *serverErrors = [[RTServerErrors alloc] init];
                serverErrors.errors = @[@"Requested reel was not found"];
                
                ServerErrorsCallback failureHandler = [failureCaptor value];
                failureHandler(serverErrors);
                
                [notJoined expectCallbackExecuted];
                expect(notJoined.callbackArguments).to.beError(RTJoinAudienceErrorDomain,
                                                               RTJoinAudienceErrorReelNotFound);
            });
            
            it(@"unknown error", ^{
                RTServerErrors *serverErrors = [[RTServerErrors alloc] init];
                serverErrors.errors = @[@"uh oh"];
                
                ServerErrorsCallback failureHandler = [failureCaptor value];
                failureHandler(serverErrors);
                
                [notJoined expectCallbackExecuted];
                expect(notJoined.callbackArguments).to.beError(RTJoinAudienceErrorDomain,
                                                               RTJoinAudienceErrorUnknownError);
            });
        });
    });
});

SpecEnd