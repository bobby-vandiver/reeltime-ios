#import "RTTestCommon.h"
#import "RTFakeClient.h"

#import "RTLoginInteractor.h"
#import "RTLoginErrors.h"

SpecBegin(RTLoginInteractor)

describe(@"login interactor", ^{
    
    __block RTLoginInteractor *interactor;
    __block RTLoginPresenter *presenter;

    __block RTFakeClient *client;
    
    __block RTClientCredentialsStore *clientCredentialsStore;
    __block RTClientCredentials *clientCredentials;
    
    __block RTOAuth2TokenStore *tokenStore;
    __block RTOAuth2Token *token;
    
    __block NSString *username = @"someone";
    __block NSString *password = @"secret";
    
    void (^expectLoginFailureError)(RTLoginErrors) = ^(RTLoginErrors expectedErrorCode) {
        MKTArgumentCaptor *errorCaptor = [[MKTArgumentCaptor alloc] init];
        [verify(presenter) loginFailedWithError:[errorCaptor capture]];
        
        expect([errorCaptor value]).to.beError(RTLoginErrorsDomain, expectedErrorCode);
    };
    
    beforeEach(^{
        clientCredentialsStore = mock([RTClientCredentialsStore class]);
        clientCredentials = [[RTClientCredentials alloc] initWithClientId:@"foo"
                                                           clientSecret:@"bar"];
        
        tokenStore = mock([RTOAuth2TokenStore class]);
        token = [[RTOAuth2Token alloc] init];
        
        presenter = mock([RTLoginPresenter class]);
        client = [[RTFakeClient alloc] init];
        
        interactor = [[RTLoginInteractor alloc] initWithPresenter:presenter
                                                           client:client
                                           clientCredentialsStore:clientCredentialsStore
                                                       tokenStore:tokenStore];
    });
    
    context(@"client credentials found", ^{
        beforeEach(^{
            [given([clientCredentialsStore loadClientCredentials]) willReturn:clientCredentials];
        });
        
        afterEach(^{
            [verify(clientCredentialsStore) loadClientCredentials];
        });
        
        describe(@"token request succeeded", ^{
            beforeEach(^{
                client.tokenShouldSucceed = YES;
                client.token = token;
            });

            it(@"should store token and notify presenter of successful login", ^{
                [[given([tokenStore storeToken:token error:nil]) withMatcher:anything() forArgument:1]
                    willReturnBool:YES];
               
                [interactor loginWithUsername:username password:password];
                
                [[verify(tokenStore) withMatcher:anything() forArgument:1] storeToken:token error:nil];
                [verify(presenter) loginSucceeded];
            });
            
            xit(@"should handle token storage error", ^{
                // TODO: Implement test case once error handling strategy is determined
            });
        });
        
        describe(@"token request failed", ^{
            beforeEach(^{
                client.tokenShouldSucceed = NO;
            });
            
            void (^expectTokenErrorCausesLoginFailureError)(RTClientTokenErrors, RTLoginErrors) =
            ^(RTClientTokenErrors tokenErrorCode, RTLoginErrors loginErrorCode) {
                
                client.tokenErrorCode = tokenErrorCode;
                
                [interactor loginWithUsername:username password:password];
                expectLoginFailureError(loginErrorCode);
            };
            
            it(@"should treat client not associated with user as an unknown client", ^{
                expectTokenErrorCausesLoginFailureError(InvalidClientCredentials, UnknownClient);
            });
            
            it(@"should notify presenter of invalid user credetials", ^{
                expectTokenErrorCausesLoginFailureError(InvalidUserCredentials, InvalidCredentials);
            });
        });
    });
    
    context(@"client credentials not found", ^{
        before(^{
            [given([clientCredentialsStore loadClientCredentials]) willReturn:nil];
        });
        
        it(@"should notify presenter of failed login due to unknown client", ^{
            [interactor loginWithUsername:username password:password];
            expectLoginFailureError(UnknownClient);
        });
    });
});

SpecEnd