#import "RTTestCommon.h"
#import "RTCallbackTestExpectation.h"

#import "RTAuthenticationAwareHTTPClient.h"

#import "RTAuthorizationHeaderSupport.h"
#import "RTCurrentUserService.h"

#import "RTOAuth2TokenRenegotiator.h"
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

    __block RTCurrentUserService *currentUserService;
    __block RTOAuth2TokenRenegotiator *tokenRenegotiator;

    __block RTAuthorizationHeaderSupport *authorizationHeaderSupport;
    __block RKObjectManager *objectManager;

    beforeEach(^{
        currentUserService = mock([RTCurrentUserService class]);
        tokenRenegotiator = mock([RTOAuth2TokenRenegotiator class]);

        authorizationHeaderSupport = mock([RTAuthorizationHeaderSupport class]);
        objectManager = mock([RKObjectManager class]);
        
        httpClient = [[RTAuthenticationAwareHTTPClient alloc] initWithCurrentUserService:currentUserService
                                                                       tokenRenegotiator:tokenRenegotiator
                                                              authorizationHeaderSupport:authorizationHeaderSupport
                                                                           objectManager:objectManager];
    });
    
    describe(@"server failure handler", ^{
        __block RTCallbackTestExpectation *callback;
        __block RTCallbackTestExpectation *retryableOperation;

        beforeEach(^{
            callback = [RTCallbackTestExpectation argsCallbackTextExpectation];
            retryableOperation = [RTCallbackTestExpectation argsCallbackTextExpectation];
        });
        
        describe(@"encountered a token error", ^{
            __block MKTArgumentCaptor *callbackCaptor;
            
            beforeEach(^{
                callbackCaptor = [[MKTArgumentCaptor alloc] init];
                
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

                [verify(tokenRenegotiator) renegotiateTokenWithCallback:[callbackCaptor capture]];
                
                [callback expectCallbackNotExecuted];
                [retryableOperation expectCallbackNotExecuted];
            });
            
            it(@"should retry operation on successful token renegotiation", ^{
                NoArgsCallback callback = [callbackCaptor value];
                callback();
                [retryableOperation expectCallbackExecuted];
            });
        });
    });
});

SpecEnd
