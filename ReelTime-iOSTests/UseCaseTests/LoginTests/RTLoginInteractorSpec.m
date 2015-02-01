#import "RTTestCommon.h"

#import "RTLoginInteractor.h"
#import "RTLoginInteractorDelegate.h"

#import "RTLoginDataManager.h"
#import "RTLoginError.h"

#import "RTClientCredentials.h"
#import "RTUserCredentials.h"
#import "RTOAuth2Token.h"

#import "RTErrorFactory.h"

SpecBegin(RTLoginInteractor)

describe(@"login interactor", ^{
    
    __block RTLoginInteractor *interactor;
    __block id<RTLoginInteractorDelegate> delegate;
    __block RTLoginDataManager *dataManager;

    __block RTClientCredentials *clientCredentials;
    __block RTOAuth2Token *token;
   
    void (^expectLoginFailureErrors)(NSArray *) = ^(NSArray *expectedErrorCodes) {
        MKTArgumentCaptor *errorCaptor = [[MKTArgumentCaptor alloc] init];
        [verify(delegate) loginFailedWithErrors:[errorCaptor capture]];
        
        NSArray *errors = [errorCaptor value];
        expect([errors count]).to.equal([expectedErrorCodes count]);
        
        for (NSNumber *errorCode in expectedErrorCodes) {
            NSError *expected = [RTErrorFactory loginErrorWithCode:[errorCode integerValue]];
            expect(errors).to.contain(expected);
        }
    };
    
    void (^expectLoginFailureError)(RTLoginError) = ^(RTLoginError expectedErrorCode) {
        expectLoginFailureErrors(@[@(expectedErrorCode)]);
    };

    beforeEach(^{
        clientCredentials = [[RTClientCredentials alloc] initWithClientId:clientId
                                                           clientSecret:clientSecret];
        token = [[RTOAuth2Token alloc] init];
        
        delegate = mockProtocol(@protocol(RTLoginInteractorDelegate));
        dataManager = mock([RTLoginDataManager class]);
        
        interactor = [[RTLoginInteractor alloc] initWithDelegate:delegate
                                                     dataManager:dataManager];
    });
    
    describe(@"login requested", ^{

        context(@"missing parameters", ^{
            it(@"should fail when username is missing", ^{
                [interactor loginWithUsername:@"" password:password];
                expectLoginFailureError(RTLoginErrorMissingUsername);
            });
            
            it(@"should fail when password is missing", ^{
                [interactor loginWithUsername:username password:@""];
                expectLoginFailureError(RTLoginErrorMissingPassword);
            });
            
            it(@"should fail when both username and password are missing", ^{
                [interactor loginWithUsername:@"" password:@""];
                expectLoginFailureErrors(@[@(RTLoginErrorMissingUsername), @(RTLoginErrorMissingPassword)]);
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
                it(@"should set logged in user on success and notify delegate of successful login", ^{
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

                    [verifyCount(dataManager, never()) setLoggedInUserWithToken:token username:username callback:anything()];

                    void (^callback)(RTOAuth2Token *token, NSString *username) = [callbackCaptor value];
                    callback(token, username);

                    MKTArgumentCaptor *nestedCallbackCaptor = [[MKTArgumentCaptor alloc] init];
                    [verify(dataManager) setLoggedInUserWithToken:token username:username callback:[nestedCallbackCaptor capture]];
                    
                    [verifyCount(delegate, never()) loginSucceeded];
                    
                    void (^nestedCallback)() = [nestedCallbackCaptor value];
                    nestedCallback();
                    
                    [verify(delegate) loginSucceeded];
                });
                
            });
        });
        
        context(@"client credentials not found", ^{
            before(^{
                [given([dataManager clientCredentialsForUsername:username]) willReturn:nil];
            });
            
            it(@"should notify delegate of failed login due to unknown client", ^{
                [interactor loginWithUsername:username password:password];
                expectLoginFailureError(RTLoginErrorUnknownClient);
            });
        });
    });
    
    describe(@"login failures", ^{
        it(@"should notify delegate of all other login errors as-is", ^{
            NSError *error = [RTErrorFactory loginErrorWithCode:RTLoginErrorUnableToStoreToken];
            
            [interactor loginDataOperationFailedWithError:error];
            expectLoginFailureError(RTLoginErrorUnableToStoreToken);
        });
        
        it(@"should notify delegate of all non-login errors as-is", ^{
            NSError *error = [NSError errorWithDomain:@"TEST" code:-1 userInfo:nil];
            
            [interactor loginDataOperationFailedWithError:error];

            MKTArgumentCaptor *errorCaptor = [[MKTArgumentCaptor alloc] init];
            [verify(delegate) loginFailedWithErrors:[errorCaptor capture]];
            
            NSArray *errors = [errorCaptor value];
            expect([errors count]).to.equal(1);

            NSError *capturedError = [errors objectAtIndex:0];
            expect(capturedError).to.equal(error);
        });
    });
});

SpecEnd