#import "RTTestCommon.h"
#import "RTServerErrorMessageToErrorCodeTestHelper.h"

#import "RTCreateReelDataManager.h"
#import "RTAPIClient.h"

#import "RTServerErrors.h"
#import "RTCreateReelError.h"

SpecBegin(RTCreateReelDataManager)

describe(@"create reel data manager", ^{
    
    __block RTCreateReelDataManager *dataManager;
    __block RTAPIClient *client;
    
    beforeEach(^{
        client = mock([RTAPIClient class]);
        dataManager = [[RTCreateReelDataManager alloc] initWithClient:client];
    });
    
    describe(@"creating a reel", ^{
        __block RTCallbackTestExpectation *created;
        __block RTCallbackTestExpectation *notCreated;
        
        __block MKTArgumentCaptor *successCaptor;
        __block MKTArgumentCaptor *failureCaptor;
        
        beforeEach(^{
            created = [RTCallbackTestExpectation noArgsCallbackTestExpectation];
            notCreated = [RTCallbackTestExpectation argsCallbackTextExpectation];
            
            successCaptor = [[MKTArgumentCaptor alloc] init];
            failureCaptor = [[MKTArgumentCaptor alloc] init];
            
            [dataManager createReelForName:reelName
                                   success:created.noArgsCallback
                                   failure:notCreated.argsCallback];
            
            [verify(client) addReelWithName:reelName
                                    success:[successCaptor capture]
                                    failure:[failureCaptor capture]];
            
            [created expectCallbackNotExecuted];
            [notCreated expectCallbackNotExecuted];
        });
        
        context(@"successful creation", ^{
            it(@"should invoke created callback on success", ^{
                NoArgsCallback successHandler = [successCaptor value];
                successHandler();
                [created expectCallbackExecuted];
            });
        });
        
        context(@"creation failed", ^{
            __block RTServerErrorMessageToErrorCodeTestHelper *helper;
            
            beforeEach(^{
                ServerErrorsCallback failureHandler = [failureCaptor value];
                
                id (^errorRetrievalBlock)() = ^{
                    return notCreated.callbackArguments;
                };
                
                helper = [[RTServerErrorMessageToErrorCodeTestHelper alloc] initForErrorDomain:RTCreateReelErrorDomain
                                                                            withFailureHandler:failureHandler
                                                                           errorRetrievalBlock:errorRetrievalBlock];
            });
            
            it(@"should map server errors to domain specific errors", ^{
                NSDictionary *mapping = @{
                                          @"[name] is required":
                                              @(RTCreateReelErrorMissingReelName),
                                          @"[name] must be at least 5 characters long":
                                              @(RTCreateReelErrorInvalidReelName),
                                          @"[name] must be no more than 25 characters long":
                                              @(RTCreateReelErrorInvalidReelName),
                                          @"[name] is reserved":
                                              @(RTCreateReelErrorReservedReelName),
                                          @"Requested reel name is not allowed":
                                              @(RTCreateReelErrorReelNameIsUnavailable),
                                          @"uh oh":
                                              @(RTCreateReelErrorUnknownError)
                                          };
                
                [helper expectForServerMessageToErrorCodeMapping:mapping];
                [notCreated expectCallbackExecuted];
            });
        });
    });
});

SpecEnd
