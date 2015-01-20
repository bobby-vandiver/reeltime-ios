#import "RTTestCommon.h"

#import "RTLoginDataManager.h"
#import "RTLoginInteractor.h"

SpecBegin(RTLoginDataManager)

describe(@"login data manager", ^{
    
    __block RTLoginDataManager *dataManager;
    __block RTLoginInteractor *interactor;
    
    __block RTClient *client;
    __block RTClientCredentialsStore *clientCredentialsStore;

    __block RTOAuth2TokenStore *tokenStore;
    __block RTCurrentUserStore *currentUserStore;

    __block RTClientCredentials *clientCredentials;
    __block RTUserCredentials *userCredentials;

    beforeEach(^{
        interactor = mock([RTLoginInteractor class]);

        client = mock([RTClient class]);
        clientCredentialsStore = mock([RTClientCredentialsStore class]);
        
        tokenStore = mock([RTOAuth2TokenStore class]);
        currentUserStore = mock([RTCurrentUserStore class]);
        
        dataManager = [[RTLoginDataManager alloc] initWithDelegate:interactor
                                                            client:client
                                            clientCredentialsStore:clientCredentialsStore
                                                        tokenStore:tokenStore
                                                  currentUserStore:currentUserStore];

        clientCredentials = [[RTClientCredentials alloc] initWithClientId:clientId
                                                             clientSecret:clientSecret];

        userCredentials = [[RTUserCredentials alloc] initWithUsername:username
                                                             password:password];
    });
    
    describe(@"load client credentials", ^{
        it(@"should return nil when not found", ^{
            [given([clientCredentialsStore loadClientCredentialsForUsername:username]) willReturn:nil];
            
            RTClientCredentials *credentials = [dataManager clientCredentialsForUsername:username];
            expect(credentials).to.beNil();
        });
        
        it(@"should return credentials when found", ^{
            [given([clientCredentialsStore loadClientCredentialsForUsername:username])
                willReturn:clientCredentials];
            
            RTClientCredentials *credentials = [dataManager clientCredentialsForUsername:username];
            expect(credentials).to.equal(clientCredentials);
        });
    });
    
    describe(@"fetching token", ^{
        __block BOOL callbackExecuted;
        
        void (^callback)(RTOAuth2Token *, NSString *) = ^(RTOAuth2Token *token, NSString *username) {
            callbackExecuted = YES;
        };
        
        beforeEach(^{
            callbackExecuted = NO;

            [dataManager fetchTokenWithClientCredentials:clientCredentials
                                         userCredentials:userCredentials
                                                callback:callback];
        });
        
        it(@"should pass token to callback on success", ^{
            MKTArgumentCaptor *successCaptor = [[MKTArgumentCaptor alloc] init];

            [verify(client) tokenWithClientCredentials:clientCredentials
                                       userCredentials:userCredentials
                                               success:[successCaptor capture]
                                               failure:anything()];
            
            expect(callbackExecuted).to.beFalsy();
            
            void (^successHandler)(RTOAuth2Token *) = [successCaptor value];
            successHandler(nil);

            expect(callbackExecuted).to.beTruthy();
        });
        
        it(@"should notify interactor of failure to retrieve token", ^{
            MKTArgumentCaptor *failureCaptor = [[MKTArgumentCaptor alloc] init];
            
            [verify(client) tokenWithClientCredentials:clientCredentials
                                       userCredentials:userCredentials
                                               success:anything()
                                               failure:[failureCaptor capture]];

            [verifyCount(interactor, never()) loginDataOperationFailedWithError:anything()];
            
            NSError *error = [NSError errorWithDomain:@"TEST" code:-1 userInfo:nil];
            void (^failureHandler)(NSError *) = [failureCaptor value];

            failureHandler(error);
            [verify(interactor) loginDataOperationFailedWithError:error];
        });
    });
    
    describe(@"setting logged in user", ^{
        __block RTOAuth2Token *token;
        
        __block MKTArgumentCaptor *errorCaptor;
        __block NSError *capturedError;
        
        __block BOOL callbackExecuted;
        
        void (^callback)() = ^(){
            callbackExecuted = YES;
        };

        beforeEach(^{
            token = [[RTOAuth2Token alloc] init];
            
            errorCaptor = [[MKTArgumentCaptor alloc] init];
            capturedError = nil;
            
            callbackExecuted = NO;
        });
        
        afterEach(^{
            [[verify(tokenStore) withMatcher:anything() forArgument:2]
             storeToken:token forUsername:username error:nil];
        });

        context(@"token successfully saved", ^{
            beforeEach(^{
                [[given([tokenStore storeToken:token forUsername:username error:nil])
                  withMatcher:anything() forArgument:2]
                 willReturnBool:YES];
            });
            
            afterEach(^{
                [[verify(currentUserStore) withMatcher:anything() forArgument:1]
                 storeCurrentUsername:username error:nil];
            });

            it(@"should set the current username and execute callback on success", ^{
                [[given([currentUserStore storeCurrentUsername:username error:nil])
                  withMatcher:anything() forArgument:1]
                 willReturnBool:YES];
                
                [dataManager setLoggedInUserWithToken:token username:username callback:callback];
                expect(callbackExecuted).to.beTruthy();
            });
            
            context(@"unable to set current username", ^{
                beforeEach(^{
                    [[given([currentUserStore storeCurrentUsername:username error:nil])
                      withMatcher:anything() forArgument:1]
                     willReturnBool:NO];
                });
                
                afterEach(^{
                    [[verify(tokenStore) withMatcher:anything() forArgument:1]
                     removeTokenForUsername:username error:nil];

                    expect(callbackExecuted).to.beFalsy();
                });
                
                it(@"should delete stored token", ^{
                    [[given([tokenStore removeTokenForUsername:username error:nil])
                      withMatcher:anything() forArgument:1]
                     willReturnBool:YES];
                    
                    [dataManager setLoggedInUserWithToken:token username:username callback:callback];
                    [verify(interactor) loginDataOperationFailedWithError:[errorCaptor capture]];
                    
                    capturedError = [errorCaptor value];
                    expect(capturedError).to.beError(RTLoginErrorDomain, LoginUnableToSetCurrentlyLoggedInUser);
                });
                
                it(@"should notify interactor of failure to delete stored token", ^{
                    [[given([tokenStore removeTokenForUsername:username error:nil])
                      withMatcher:anything() forArgument:1]
                     willReturnBool:NO];
                    
                    [dataManager setLoggedInUserWithToken:token username:username callback:callback];
                    [verify(interactor) loginDataOperationFailedWithError:[errorCaptor capture]];
                    
                    capturedError = [errorCaptor value];
                    expect(capturedError).to.beError(RTLoginErrorDomain, LoginUnableToRemoveToken);
                });
            });
            
        });
        
        context(@"token save failure", ^{
            beforeEach(^{
                [[given([tokenStore storeToken:token forUsername:username error:nil])
                  withMatcher:anything() forArgument:2]
                 willReturnBool:NO];
            });
            
            it(@"should notify interactor of failure to save token", ^{
                [dataManager setLoggedInUserWithToken:token username:username callback:callback];
                [verify(interactor) loginDataOperationFailedWithError:[errorCaptor capture]];
                
                capturedError = [errorCaptor value];
                expect(capturedError).to.beError(RTLoginErrorDomain, LoginUnableToStoreToken);
                
                expect(callbackExecuted).to.beFalsy();
            });
        });
    });
});

SpecEnd