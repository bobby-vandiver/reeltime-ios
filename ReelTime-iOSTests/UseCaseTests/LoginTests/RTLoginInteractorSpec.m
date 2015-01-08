#import "RTTestCommon.h"
#import "RTFakeClient.h"

#import "RTLoginInteractor.h"
#import "RTLoginPresenter.h"
#import "RTLoginDataManager.h"
#import "RTLoginErrors.h"

SpecBegin(RTLoginInteractor)

/*
describe(@"login interactor", ^{
    
    __block RTLoginInteractor *interactor;
    __block RTLoginPresenter *presenter;
    __block RTLoginDataManager *dataManager;

    __block RTFakeClient *client;

    __block RTClientCredentials *clientCredentials;
    __block RTOAuth2Token *token;
   
    __block NSString *username = @"someone";
    __block NSString *password = @"secret";
    
    void (^expectLoginFailureError)(RTLoginErrors) = ^(RTLoginErrors expectedErrorCode) {
        MKTArgumentCaptor *errorCaptor = [[MKTArgumentCaptor alloc] init];
        [verify(presenter) loginFailedWithError:[errorCaptor capture]];
        
        expect([errorCaptor value]).to.beError(RTLoginErrorDomain, expectedErrorCode);
    };
    
    beforeEach(^{
        clientCredentials = [[RTClientCredentials alloc] initWithClientId:@"foo"
                                                           clientSecret:@"bar"];
        token = [[RTOAuth2Token alloc] init];
        
        presenter = mock([RTLoginPresenter class]);
        dataManager = mock([RTLoginDataManager class]);
        client = [[RTFakeClient alloc] init];
        
        interactor = [[RTLoginInteractor alloc] initWithPresenter:presenter
                                                      dataManager:dataManager
                                                           client:client];
    });
    
    context(@"client credentials found", ^{
        beforeEach(^{
            [given([dataManager clientCredentialsForUsername:username]) willReturn:clientCredentials];
        });
        
        afterEach(^{
            [verify(dataManager) clientCredentialsForUsername:username];
        });
        
        describe(@"token request succeeded", ^{
            beforeEach(^{
                client.tokenShouldSucceed = YES;
                client.token = token;
            });
            
            afterEach(^{
                [[verify(dataManager) withMatcher:anything() forArgument:2] rememberToken:token forUsername:username error:nil];
            });

            context(@"token was stored successfully", ^{
                beforeEach(^{
                    [[given([dataManager rememberToken:token forUsername:username error:nil]) withMatcher:anything() forArgument:2]
                     willReturnBool:YES];
                });
            
                it(@"should set current username and notify presenter of successful login", ^{
                    [[given([dataManager setCurrentlyLoggedInUsername:username error:nil]) withMatcher:anything() forArgument:1] willReturnBool:YES];
                   
                    [interactor loginWithUsername:username password:password];
                    
                    [[verify(dataManager) withMatcher:anything() forArgument:1]
                        setCurrentlyLoggedInUsername:username error:nil];

                    [verify(presenter) loginSucceeded];
                });
                
                it(@"should remove token and notify presenter of failure to set current username", ^{
                    [[given([dataManager setCurrentlyLoggedInUsername:username error:nil]) withMatcher:anything() forArgument:1] willReturnBool:NO];

                    [interactor loginWithUsername:username password:password];
                    
                    [[verify(dataManager) withMatcher:anything() forArgument:1]
                     setCurrentlyLoggedInUsername:username error:nil];

                    [[verify(dataManager) withMatcher:anything() forArgument:1] forgetTokenForUsername:username error:nil];
                   
                    [[verify(presenter) withMatcher:anything() forArgument:1] loginFailedWithError:nil];
                });
            });
            
            it(@"should notify presenter of token storage error", ^{
                [[given([dataManager rememberToken:token forUsername:username error:nil]) withMatcher:anything() forArgument:2]
                 willReturnBool:NO];
                
                [interactor loginWithUsername:username password:password];
                [[verify(presenter) withMatcher:anything() forArgument:1] loginFailedWithError:nil];
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
            [given([dataManager clientCredentialsForUsername:username]) willReturn:nil];
        });
        
        it(@"should notify presenter of failed login due to unknown client", ^{
            [interactor loginWithUsername:username password:password];
            expectLoginFailureError(UnknownClient);
        });
    });
});
*/
SpecEnd