#import "RTTestCommon.h"
#import "RTCallbackTestExpectation.h"

#import "RTOAuth2TokenRenegotiator.h"
#import "RTAPIClient.h"

#import "RTCurrentUserService.h"
#import "RTLoginWireframe.h"

#import "RTClientCredentials.h"

#import "RTOAuth2Token.h"
#import "RTOAuth2TokenError.h"

#import "RTOAuth2TokenRenegotiationStatus.h"
#import "RTLoginNotification.h"

@interface RTOAuth2TokenRenegotiator (Test)

- (void)receivedLoginDidSucceedNotification:(NSNotification *)notification;

@end

SpecBegin(RTOAuth2TokenRenegotiator)

describe(@"token renegotiator", ^{

    __block RTOAuth2TokenRenegotiator *renegotiator;
    __block RTAPIClient *client;

    __block RTCurrentUserService *currentUserService;
    __block RTLoginWireframe *loginWireframe;
    
    __block RTOAuth2TokenRenegotiationStatus *tokenRenegotiationStatus;
    __block NSNotificationCenter *notificationCenter;
    
    __block RTOAuth2Token *token;
    __block RTClientCredentials *clientCredentials;
    
    __block NSNotification *loginSucceededNotification;
    
    beforeEach(^{
        client = mock([RTAPIClient class]);
        
        currentUserService = mock([RTCurrentUserService class]);
        loginWireframe = mock([RTLoginWireframe class]);
        
        tokenRenegotiationStatus = [[RTOAuth2TokenRenegotiationStatus alloc] init];
        notificationCenter = mock([NSNotificationCenter class]);

        renegotiator = [[RTOAuth2TokenRenegotiator alloc] initWithClient:client
                                                      currentUserService:currentUserService
                                                          loginWireframe:loginWireframe
                                                tokenRenegotiationStatus:tokenRenegotiationStatus
                                                      notificationCenter:notificationCenter];
        
        token = [[RTOAuth2Token alloc] init];
        clientCredentials = [[RTClientCredentials alloc] initWithClientId:clientId
                                                             clientSecret:clientSecret];
        
        loginSucceededNotification = [[NSNotification alloc] initWithName:RTLoginDidSucceedNotification
                                                                   object:anything()
                                                                 userInfo:anything()];
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
            beforeEach(^{
                [renegotiator renegotiateTokenWithCallback:renegotiationSuccess.noArgsCallback];
                
                [verify(client) refreshToken:token
                       withClientCredentials:clientCredentials
                                     success:[successCaptor capture]
                                     failure:[failureCaptor capture]];
                
                [renegotiationSuccess expectCallbackNotExecuted];
                
                expect(tokenRenegotiationStatus.renegotiationInProgress).to.beTruthy();
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
                        [renegotiator receivedLoginDidSucceedNotification:loginSucceededNotification];
                        expect(tokenRenegotiationStatus.renegotiationInProgress).to.beFalsy();
                    });
                });
            });
        });
    });
    
    describe(@"received login notification when renegotiation not in progress", ^{
        beforeEach(^{
            expect(tokenRenegotiationStatus.renegotiationInProgress).to.beFalsy();
            expect(tokenRenegotiationStatus.lastRenegotiationSucceeded).to.beFalsy();
        });
        
        it(@"should do nothing", ^{
            [renegotiator receivedLoginDidSucceedNotification:loginSucceededNotification];
            expect(tokenRenegotiationStatus.lastRenegotiationSucceeded).to.beFalsy();
        });
    });
});

SpecEnd