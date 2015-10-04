#import "RTTestCommon.h"
#import "RTCallbackTestExpectation.h"

#import "RTAuthenticationAwareHTTPClientDelegate.h"

#import "RTAPIClient.h"

#import "RTCurrentUserService.h"
#import "RTLoginWireframe.h"

#import "RTClientCredentials.h"

#import "RTOAuth2Token.h"
#import "RTOAuth2TokenError.h"

#import "RTOAuth2TokenRenegotiationStatus.h"
#import "RTLoginNotification.h"

@interface RTAuthenticationAwareHTTPClientDelegate (Test)

- (void)receivedLoginDidSucceedNotification:(NSNotification *)notification;

@end

SpecBegin(RTAuthenticationAwareHTTPClientDelegate)

describe(@"http client delegate", ^{
    __block RTAuthenticationAwareHTTPClientDelegate *delegate;
    
    __block RTAPIClient *client;
    
    __block RTCurrentUserService *currentUserService;
    __block RTLoginWireframe *loginWireframe;

    __block RTOAuth2TokenRenegotiationStatus *tokenRenegotiationStatus;
    __block NSNotificationCenter *notificationCenter;
    
    __block RTOAuth2Token *token;
    __block RTClientCredentials *clientCredentials;

    beforeEach(^{
        client = mock([RTAPIClient class]);
        
        currentUserService = mock([RTCurrentUserService class]);
        loginWireframe = mock([RTLoginWireframe class]);
        
        tokenRenegotiationStatus = [[RTOAuth2TokenRenegotiationStatus alloc] init];
        notificationCenter = mock([NSNotificationCenter class]);
        
        delegate = [[RTAuthenticationAwareHTTPClientDelegate alloc] initWithAPIClient:client
                                                                   currentUserService:currentUserService
                                                                       loginWireframe:loginWireframe
                                                             tokenRenegotiationStatus:tokenRenegotiationStatus
                                                                   notificationCenter:notificationCenter];

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
        
        __block MKTArgumentCaptor *successCaptor;
        __block MKTArgumentCaptor *failureCaptor;
        
        beforeEach(^{
            renegotiationSuccess = [RTCallbackTestExpectation noArgsCallbackTestExpectation];
            
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
                                             withCallback:renegotiationSuccess.noArgsCallback];
                
                [verify(client) refreshToken:token
                       withClientCredentials:clientCredentials
                                     success:[successCaptor capture]
                                     failure:[failureCaptor capture]];
                
                [renegotiationSuccess expectCallbackNotExecuted];
            });

            context(@"successfully refreshed token", ^{
                __block TokenCallback successHandler;
                
                beforeEach(^{
                    successHandler = [successCaptor value];
                });
                
                it(@"should invoke callback when successfully storing token", ^{
                    [given([currentUserService storeTokenForCurrentUser:token]) willReturnBool:YES];
                    successHandler(token);
                    [renegotiationSuccess expectCallbackExecuted];
                });
                
                it(@"should not invoke callback when storing token fails", ^{
                    [given([currentUserService storeTokenForCurrentUser:token]) willReturnBool:NO];
                    successHandler(token);
                    [renegotiationSuccess expectCallbackNotExecuted];
                });
            });
            
            context(@"refresh token has expired", ^{
                __block TokenErrorCallback failureHandler;
                __block RTOAuth2TokenError *tokenError;

                beforeEach(^{
                    failureHandler = [failureCaptor value];
                });
                
                context(@"refresh attempted failed due to invalid_token", ^{
                    beforeEach(^{
                        tokenError = [[RTOAuth2TokenError alloc] initWithErrorCode:@"invalid_token"
                                                                  errorDescription:@"Invalid refresh token (expired): access-token"];
                        failureHandler(tokenError);
                    });
                    
                    it(@"should present relogin interface", ^{
                        [verify(loginWireframe) presentReloginInterface];
                    });
                    
                    it(@"should not execute callback until successufl login notification is recevied", ^{
                        [renegotiationSuccess expectCallbackNotExecuted];
                        
                        NSNotification *notification = [[NSNotification alloc] initWithName:RTLoginDidSucceedNotification
                                                                                     object:anything()
                                                                                   userInfo:anything()];

                        [delegate receivedLoginDidSucceedNotification:notification];
                        [renegotiationSuccess expectCallbackNotExecuted];
                    });
                });
            });
        });
    });
});

SpecEnd