#import "RTTestCommon.h"

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
            it(@"reel not found", ^{
                RTServerErrors *serverErrors = [[RTServerErrors alloc] init];
                serverErrors.errors = @[@"Requested reel was not found"];
                
                ServerErrorsCallback failureHandler = [failureCaptor value];
                failureHandler(serverErrors);
                
                [notLeft expectCallbackExecuted];
                expect(notLeft.callbackArguments).to.beError(RTLeaveAudienceErrorDomain,
                                                             RTLeaveAudienceErrorReelNotFound);
            });
            
            it(@"unknown error", ^{
                RTServerErrors *serverErrors = [[RTServerErrors alloc] init];
                serverErrors.errors = @[@"uh oh"];
                
                ServerErrorsCallback failureHandler = [failureCaptor value];
                failureHandler(serverErrors);
                
                [notLeft expectCallbackExecuted];
                expect(notLeft.callbackArguments).to.beError(RTLeaveAudienceErrorDomain,
                                                             RTLeaveAudienceErrorUnknownError);
            });

        });
    });
});

SpecEnd
