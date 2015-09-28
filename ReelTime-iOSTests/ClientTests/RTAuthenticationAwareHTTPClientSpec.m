#import "RTTestCommon.h"
#import "RTCallbackTestExpectation.h"

#import "RTAuthenticationAwareHTTPClient.h"
#import "RTAuthenticationAwareHTTPClientDelegate.h"

#import "RTOAuth2TokenError.h"

#import <RestKit/RestKit.h>
#import <RKMappingErrors.h>

#import "RKObjectManager+IncludeHeaders.h"

@interface RTAuthenticationAwareHTTPClient (Test)

- (RKFailureCallback)serverFailureHandlerWithCallback:(ArgsCallback)callback
                                forRetryableOperation:(NoArgsCallback)retryableOperation
                                        authenticated:(BOOL)authenticated;
@end


SpecBegin(RTAuthenticationAwareHTTPClient)

describe(@"authentication aware http client", ^{
    
    __block RTAuthenticationAwareHTTPClient *httpClient;
    __block RTAuthenticationAwareHTTPClientDelegate *delegate;
    
    __block RKObjectManager *objectManager;
    __block MKTArgumentCaptor *captor;

    beforeEach(^{
        delegate = mock([RTAuthenticationAwareHTTPClientDelegate class]);
        objectManager = mock([RKObjectManager class]);
        
        httpClient = [[RTAuthenticationAwareHTTPClient alloc] initWithDelegate:delegate
                                                          restKitObjectManager:objectManager];
        
        captor = [[MKTArgumentCaptor alloc] init];
    });
    
    
    describe(@"server failure handler", ^{
        __block RTCallbackTestExpectation *callback;
        __block RTCallbackTestExpectation *retryableOperation;

        beforeEach(^{
            callback = [RTCallbackTestExpectation argsCallbackTextExpectation];
            retryableOperation = [RTCallbackTestExpectation argsCallbackTextExpectation];
        });
        
        describe(@"encountered a token error", ^{
            __block MKTArgumentCaptor *successCaptor;
            __block MKTArgumentCaptor *failureCaptor;
            
            beforeEach(^{
                successCaptor = [[MKTArgumentCaptor alloc] init];
                failureCaptor = [[MKTArgumentCaptor alloc] init];
                
                RKFailureCallback failureCallback = [httpClient serverFailureHandlerWithCallback:callback.argsCallback
                                                                                forRetryableOperation:retryableOperation.argsCallback
                                                                                   authenticated:YES];
                
                RKObjectRequestOperation *operation = mock([RKObjectRequestOperation class]);
                RTOAuth2TokenError *tokenError = [[RTOAuth2TokenError alloc] initWithErrorCode:@"token_error"
                                                                              errorDescription:@"test"];
                NSError *error = [NSError errorWithDomain:RKErrorDomain
                                                     code:RKMappingErrorFromMappingResult
                                                 userInfo:@{ RKObjectMapperErrorObjectsKey: @[tokenError] }];
                
                failureCallback(operation, error);
                [verify(delegate) renegotiateTokenDueToTokenError:[captor capture]
                                                          success:[successCaptor capture]
                                                          failure:[failureCaptor capture]];
                
                [callback expectCallbackNotExecuted];
                [retryableOperation expectCallbackNotExecuted];
            });

            it(@"should pass token error to delegate", ^{
                RTOAuth2TokenError *captured = (RTOAuth2TokenError *)captor.value;
                expect(captured.errorCode).to.equal(@"token_error");
                expect(captured.errorDescription).to.equal(@"test");
            });
            
            it(@"should retry operation on successful token renegotiation", ^{
                NoArgsCallback successHandler = [successCaptor value];
                successHandler();
                [retryableOperation expectCallbackExecuted];
            });
        });
    });
});

SpecEnd
