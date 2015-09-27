#import "RTTestCommon.h"

#import "RTAuthenticationAwareHTTPClient.h"
#import "RTAuthenticationAwareHTTPClientDelegate.h"

#import "RTOAuth2TokenError.h"

#import <RestKit/RestKit.h>
#import <RKMappingErrors.h>

#import "RKObjectManager+IncludeHeaders.h"

@interface RTAuthenticationAwareHTTPClient (Test)

- (RKFailureCallback)serverFailureHandlerWithCallback:(Callback)callback
                                     forHTTPOperation:(RKHTTPOperation)httpOperation
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
        __block BOOL callbackExecuted;
        __block Callback callback;
        
        __block BOOL httpOperationExecuted;
        __block RKHTTPOperation httpOperation;
        
        beforeEach(^{
            callbackExecuted = NO;
            callback = ^(id errors) {
                callbackExecuted = YES;
            };
            
            httpOperationExecuted = NO;
            httpOperation = ^(RKSuccessCallback successCallback, RKFailureCallback failureCallback) {
                httpOperationExecuted = YES;
            };
        });
        
        it(@"encountered a token error", ^{
            RKFailureCallback failureCallback = [httpClient serverFailureHandlerWithCallback:callback
                                                                            forHTTPOperation:httpOperation
                                                                               authenticated:YES];
            
            RKObjectRequestOperation *operation = mock([RKObjectRequestOperation class]);
            
            RTOAuth2TokenError *tokenError = [[RTOAuth2TokenError alloc] initWithErrorCode:@"token_error"
                                                                          errorDescription:@"test"];
            
            NSError *error = [NSError errorWithDomain:RKErrorDomain
                                                 code:RKMappingErrorFromMappingResult
                                             userInfo:@{ RKObjectMapperErrorObjectsKey: @[tokenError] }];
            
            failureCallback(operation, error);
            
            [verify(delegate) authenticatedRequestFailedWithTokenError:[captor capture]];
            
            RTOAuth2TokenError *captured = (RTOAuth2TokenError *)captor.value;
            expect(captured.errorCode).to.equal(@"token_error");
            expect(captured.errorDescription).to.equal(@"test");
        });
    });
});

SpecEnd
