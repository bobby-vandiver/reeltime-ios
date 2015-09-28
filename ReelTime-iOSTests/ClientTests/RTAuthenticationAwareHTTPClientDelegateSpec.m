#import "RTTestCommon.h"
#import "RTCallbackTestExpectation.h"

#import "RTAuthenticationAwareHTTPClientDelegate.h"

#import "RTAPIClient.h"
#import "RTCurrentUserService.h"

#import "RTClientCredentials.h"

#import "RTOAuth2Token.h"
#import "RTOAuth2TokenError.h"

SpecBegin(RTAuthenticationAwareHTTPClientDelegate)

describe(@"http client delegate", ^{
    __block RTAuthenticationAwareHTTPClientDelegate *delegate;
    
    __block RTAPIClient *client;
    __block RTCurrentUserService *currentUserService;

    __block RTOAuth2Token *token;
    __block RTClientCredentials *clientCredentials;

    beforeEach(^{
        client = mock([RTAPIClient class]);
        currentUserService = mock([RTCurrentUserService class]);
        
        delegate = [[RTAuthenticationAwareHTTPClientDelegate alloc] initWithAPIClient:client
                                                                   currentUserService:currentUserService];

        token = [[RTOAuth2Token alloc] init];
        clientCredentials = [[RTClientCredentials alloc] initWithClientId:clientId
                                                             clientSecret:clientSecret];
    });
    
    describe(@"getting access token for current user", ^{
        beforeEach(^{
            token.accessToken = @"access-token";

            [given([currentUserService tokenForCurrentUser]) willReturn:token];
        });

        afterEach(^{
            [verify(currentUserService) tokenForCurrentUser];
        });
        
        it(@"should delegate to current user service to get token", ^{
            NSString *accessToken = [delegate accessTokenForCurrentUser];
            expect(accessToken).to.equal(@"access-token");
        });
    });
    
    describe(@"renegotiating token", ^{
        __block RTCallbackTestExpectation *renegotiationSuccess;
        __block RTCallbackTestExpectation *renegotiationFailure;
        
        __block MKTArgumentCaptor *successCaptor;
        __block MKTArgumentCaptor *failureCaptor;
        
        beforeEach(^{
            renegotiationSuccess = [RTCallbackTestExpectation noArgsCallbackTestExpectation];
            renegotiationFailure = [RTCallbackTestExpectation noArgsCallbackTestExpectation];
            
            successCaptor = [[MKTArgumentCaptor alloc] init];
            failureCaptor = [[MKTArgumentCaptor alloc] init];
            
            [given([currentUserService tokenForCurrentUser]) willReturn:token];
            [given([currentUserService clientCredentialsForCurrentUser]) willReturn:clientCredentials];
        });
        
        context(@"access token has expired", ^{
            __block RTOAuth2TokenError *tokenError;
            
            beforeEach(^{
                tokenError = [[RTOAuth2TokenError alloc] initWithErrorCode:@"invalid_token"
                                                          errorDescription:@"Access token expired: access-token"];
                
                [delegate renegotiateTokenDueToTokenError:tokenError
                                                  success:renegotiationSuccess.noArgsCallback
                                                  failure:renegotiationFailure.noArgsCallback];
                
                [verify(client) refreshToken:token
                       withClientCredentials:clientCredentials
                                     success:[successCaptor capture]
                                     failure:[failureCaptor capture]];
                
                [renegotiationSuccess expectCallbackNotExecuted];
                [renegotiationFailure expectCallbackNotExecuted];
            });

            context(@"successfully refreshed token", ^{
                __block NoArgsCallback successHandler;
                
                beforeEach(^{
                    successHandler = [successCaptor value];
                });
                
                it(@"should invoke success callback when successfully storing token", ^{
                    [given([currentUserService storeTokenForCurrentUser:token]) willReturnBool:YES];
                    successHandler(token);
                    [renegotiationSuccess expectCallbackExecuted];
                });
                
                it(@"should invoke failure callback when storing token fails", ^{
                    [given([currentUserService storeTokenForCurrentUser:token]) willReturnBool:NO];
                    successHandler(token);
                    [renegotiationFailure expectCallbackExecuted];
                });
            });
        });
    });
});

SpecEnd