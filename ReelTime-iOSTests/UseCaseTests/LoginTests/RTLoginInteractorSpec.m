#import "RTTestCommon.h"

#import "RTLoginInteractor.h"
#import "RTLoginInteractor+RTLoginDataManagerDelegate.h"
#import "RTLoginPresenter.h"
#import "RTLoginDataManager.h"
#import "RTLoginErrors.h"

#import "RTErrorFactory.h"

SpecBegin(RTLoginInteractor)

describe(@"login interactor", ^{
    
    __block RTLoginInteractor *interactor;
    __block RTLoginPresenter *presenter;
    __block RTLoginDataManager *dataManager;

    __block RTClientCredentials *clientCredentials;
    __block RTOAuth2Token *token;
   
    __block NSString *clientId = @"foo";
    __block NSString *clientSecret = @"bar";
    
    __block NSString *username = @"someone";
    __block NSString *password = @"secret";
    
    void (^expectLoginFailureError)(RTLoginErrors) = ^(RTLoginErrors expectedErrorCode) {
        MKTArgumentCaptor *errorCaptor = [[MKTArgumentCaptor alloc] init];
        [verify(presenter) loginFailedWithError:[errorCaptor capture]];
        
        expect([errorCaptor value]).to.beError(RTLoginErrorDomain, expectedErrorCode);
    };

    beforeEach(^{
        clientCredentials = [[RTClientCredentials alloc] initWithClientId:clientId
                                                           clientSecret:clientSecret];
        token = [[RTOAuth2Token alloc] init];
        
        presenter = mock([RTLoginPresenter class]);
        dataManager = mock([RTLoginDataManager class]);
        
        interactor = [[RTLoginInteractor alloc] initWithPresenter:presenter
                                                      dataManager:dataManager];
    });
    
    describe(@"login requested", ^{

        context(@"missing parameters", ^{
            it(@"should fail when username is missing", ^{
                [interactor loginWithUsername:@"" password:password];
                expectLoginFailureError(MissingUsername);
            });
            
            it(@"should fail when password is missing", ^{
                [interactor loginWithUsername:username password:@""];
                expectLoginFailureError(MissingPassword);
            });
        });

        context(@"client credentials found", ^{
            beforeEach(^{
                [given([dataManager clientCredentialsForUsername:username]) willReturn:clientCredentials];
            });
            
            afterEach(^{
                [verify(dataManager) clientCredentialsForUsername:username];
            });
            
            describe(@"when fetching a token", ^{
                it(@"should set logged in user on success", ^{
                    [interactor loginWithUsername:username password:password];
                    
                    MKTArgumentCaptor *clientCredentialsCaptor= [[MKTArgumentCaptor alloc] init];
                    MKTArgumentCaptor *userCredentialsCaptor = [[MKTArgumentCaptor alloc] init];
                    MKTArgumentCaptor *callbackCaptor = [[MKTArgumentCaptor alloc] init];
                    
                    [verify(dataManager) fetchTokenWithClientCredentials:[clientCredentialsCaptor capture]
                                                         userCredentials:[userCredentialsCaptor capture]
                                                                callback:[callbackCaptor capture]];
                    
                    RTUserCredentials *userCredentialsArg = [userCredentialsCaptor value];
                    expect(userCredentialsArg.username).to.equal(username);
                    expect(userCredentialsArg.password).to.equal(password);
                    
                    RTClientCredentials *clientCredentialsArg = [clientCredentialsCaptor value];
                    expect(clientCredentialsArg.clientId).to.equal(clientId);
                    expect(clientCredentialsArg.clientSecret).to.equal(clientSecret);

                    [verifyCount(dataManager, never()) setLoggedInUserWithToken:token username:username];

                    void (^callback)(RTOAuth2Token *token, NSString *username) = [callbackCaptor value];
                    callback(token, username);

                    [verify(dataManager) setLoggedInUserWithToken:token username:username];
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
    
    describe(@"successful login", ^{
        it(@"should notify presenter of successful login", ^{
            [interactor didSetLoggedInUser];
            [verify(presenter) loginSucceeded];
        });
    });
    
    describe(@"login failures", ^{
        it(@"should treat client with bad credentials or not associated with user as an unknown client", ^{
            NSError *error = [RTErrorFactory clientTokenErrorWithCode:InvalidClientCredentials];

            [interactor loginDataOperationFailedWithError:error];
            expectLoginFailureError(UnknownClient);
        });
        
        it(@"should notify presenter of invalid user credetials", ^{
            NSError *error = [RTErrorFactory clientTokenErrorWithCode:InvalidUserCredentials];
            
            [interactor loginDataOperationFailedWithError:error];
            expectLoginFailureError(InvalidCredentials);
        });
        
        it(@"should notify presenter of all other errors as-is", ^{
            NSError *error = [RTErrorFactory loginErrorWithCode:UnableToStoreToken];
            
            [interactor loginDataOperationFailedWithError:error];
            expectLoginFailureError(UnableToStoreToken);
        });
    });
});

SpecEnd