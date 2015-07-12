#import "RTTestCommon.h"
#import "RTServerErrorMessageToErrorCodeTestHelper.h"

#import "RTChangeDisplayNameDataManager.h"
#import "RTAPIClient.h"

#import "RTChangeDisplayNameError.h"

SpecBegin(RTChangeDisplayNameDataManager)

describe(@"change display name data manager", ^{
    
    __block RTChangeDisplayNameDataManager *dataManager;
    __block RTAPIClient *client;
    
    __block RTCallbackTestExpectation *changed;
    __block RTCallbackTestExpectation *notChanged;
    
    __block RTServerErrorMessageToErrorCodeTestHelper *helper;
    
    __block MKTArgumentCaptor *successCaptor;
    __block MKTArgumentCaptor *failureCaptor;
    
    beforeEach(^{
        client = mock([RTAPIClient class]);
        dataManager =  [[RTChangeDisplayNameDataManager alloc] initWithClient:client];
        
        changed = [RTCallbackTestExpectation noArgsCallbackTestExpectation];
        notChanged = [RTCallbackTestExpectation argsCallbackTextExpectation];
        
        successCaptor = [[MKTArgumentCaptor alloc] init];
        failureCaptor = [[MKTArgumentCaptor alloc] init];
    });
 
    describe(@"changing display name", ^{
        beforeEach(^{
            [dataManager changeDisplayName:displayName
                                   changed:changed.noArgsCallback
                                notChanged:notChanged.argsCallback];
            
            [verify(client) changeDisplayName:displayName
                                      success:[successCaptor capture]
                                      failure:[failureCaptor capture]];
            
            [changed expectCallbackNotExecuted];
            [notChanged expectCallbackNotExecuted];
            
            ServerErrorsCallback failureHandler = [failureCaptor value];
            
            NSArray *(^errorRetrievalBlock)() = ^{
                return notChanged.callbackArguments;
            };
            
            helper = [[RTServerErrorMessageToErrorCodeTestHelper alloc] initForErrorDomain:RTChangeDisplayNameErrorDomain
                                                                        withFailureHandler:failureHandler
                                                                       errorRetrievalBlock:errorRetrievalBlock];
        });
        
        it(@"should invoke changed callback on successful change", ^{
            NoArgsCallback successHandler = [successCaptor value];
            successHandler();
            [changed expectCallbackExecuted];
        });
        
        it(@"should map server errors to domain specific errors", ^{
            NSDictionary *mapping = @{
                                     @"[new_display_name] is required":
                                         @(RTChangeDisplayNameErrorMissingDisplayName),
                                     @"[new_display_name] must be 2-20 alphanumeric or space characters long":
                                         @(RTChangeDisplayNameErrorInvalidDisplayName)
                                     };
            
            [helper expectForServerMessageToErrorCodeMapping:mapping];
            [notChanged expectCallbackExecuted];
        });
    });
});

SpecEnd