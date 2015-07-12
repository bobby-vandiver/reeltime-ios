#import "RTTestCommon.h"
#import "RTServerErrorMessageToErrorCodeTestHelper.h"

#import "RTLogoutDataManager.h"
#import "RTAPIClient.h"

#import "RTOAuth2TokenStore.h"
#import "RTCurrentUserStore.h"

#import "RTOAuth2Token.h"
#import "RTLogoutError.h"

#import "RTServerErrors.h"

SpecBegin(RTLogoutDataManager)

describe(@"logout data manager", ^{
    
    __block RTLogoutDataManager *dataManager;
    __block RTAPIClient *client;
    
    __block RTOAuth2TokenStore *tokenStore;
    __block RTCurrentUserStore *currentUserStore;
    
    __block MKTArgumentCaptor *successCaptor;
    __block MKTArgumentCaptor *failureCaptor;

    beforeEach(^{
        client = mock([RTAPIClient class]);

        tokenStore = mock([RTOAuth2TokenStore class]);
        currentUserStore = mock([RTCurrentUserStore class]);
        
        dataManager = [[RTLogoutDataManager alloc] initWithClient:client
                                                       tokenStore:tokenStore
                                                 currentUserStore:currentUserStore];
        
        successCaptor = [[MKTArgumentCaptor alloc] init];
        failureCaptor = [[MKTArgumentCaptor alloc] init];
    });
    
    void (^stubLoadCurrentUsername)(NSString *) = ^(NSString *username) {
        [[given([currentUserStore loadCurrentUsernameWithError:nil])
          withMatcher:anything() forArgument:0] willReturn:username];
    };
    
    void (^stubRemoveCurrentUsername)(BOOL) = ^(BOOL removed) {
        [[given([currentUserStore removeCurrentUsernameWithError:nil])
          withMatcher:anything() forArgument:0] willReturnBool:removed];
    };
    
    void (^stubLoadTokenForUsername)(NSString *, RTOAuth2Token *) = ^(NSString *username, RTOAuth2Token *token) {
        [[given([tokenStore loadTokenForUsername:username error:nil])
          withMatcher:anything() forArgument:1] willReturn:token];
    };
    
    void (^stubRemoveTokenForUsername)(NSString *, BOOL) = ^(NSString *username, BOOL removed) {
        [[given([tokenStore removeTokenForUsername:username error:nil])
          withMatcher:anything() forArgument:1] willReturnBool:removed];
    };
    
    describe(@"revoking current token", ^{
        __block RTCallbackTestExpectation *revocationSuccess;
        __block RTCallbackTestExpectation *revocationFailure;

        __block RTOAuth2Token *token;

        beforeEach(^{
            revocationSuccess = [RTCallbackTestExpectation noArgsCallbackTestExpectation];
            revocationFailure = [RTCallbackTestExpectation argsCallbackTextExpectation];

            token = [[RTOAuth2Token alloc] init];
            token.accessToken = accessToken;
            
            [revocationSuccess expectCallbackNotExecuted];
            [revocationFailure expectCallbackNotExecuted];
        });
        
        context(@"local credentials are not present", ^{
            afterEach(^{
                [verifyCount(client, never()) revokeAccessToken:anything() success:anything() failure:anything()];
            });
            
            it(@"current username not found", ^{
                stubLoadCurrentUsername(nil);
                
                [dataManager revokeCurrentTokenWithSuccess:anything() failure:revocationFailure.argsCallback];
                [revocationFailure expectCallbackExecuted];
                
                NSError *error = revocationFailure.callbackArguments;
                expect(error).to.beError(RTLogoutErrorDomain, RTLogoutErrorCurrentUsernameNotFound);
            });
            
            it(@"token not found", ^{
                stubLoadCurrentUsername(username);
                stubLoadTokenForUsername(username, nil);
                
                [dataManager revokeCurrentTokenWithSuccess:anything() failure:revocationFailure.argsCallback];
                [revocationFailure expectCallbackExecuted];
                
                NSError *error = revocationFailure.callbackArguments;
                expect(error).to.beError(RTLogoutErrorDomain, RTLogoutErrorMissingAccessToken);
            });
        });

        context(@"local credentials are found", ^{
            beforeEach(^{
                stubLoadCurrentUsername(username);
                stubLoadTokenForUsername(username, token);
                
                [dataManager revokeCurrentTokenWithSuccess:revocationSuccess.noArgsCallback
                                                   failure:revocationFailure.argsCallback];
                
                [verify(client) revokeAccessToken:accessToken
                                          success:[successCaptor capture]
                                          failure:[failureCaptor capture]];
            });
            
            it(@"token revocation success", ^{
                NoArgsCallback successHandler = [successCaptor value];
                successHandler();
                [revocationSuccess expectCallbackExecuted];
            });

            it(@"token revocation failure due to missing access token", ^{
                RTServerErrors *serverErrors = [[RTServerErrors alloc] init];
                serverErrors.errors = @[@"[access_token] is required"];
                
                ServerErrorsCallback failureHandler = [failureCaptor value];
                failureHandler(serverErrors);
                
                [revocationFailure expectCallbackExecuted];
                expect(revocationFailure.callbackArguments).to.beError(RTLogoutErrorDomain, RTLogoutErrorMissingAccessToken);
            });
            
            it(@"unexpected token revocation failure", ^{
                RTServerErrors *serverErrors = [[RTServerErrors alloc] init];
                serverErrors.errors = @[@"unexpected error"];
                
                ServerErrorsCallback failureHandler = [failureCaptor value];
                failureHandler(serverErrors);
                
                [revocationFailure expectCallbackExecuted];
                expect(revocationFailure.callbackArguments).to.beError(RTLogoutErrorDomain, RTLogoutErrorUnknownRevocationError);
            });
        });
    });
    
    describe(@"removing local credentials", ^{
        __block RTCallbackTestExpectation *credentialsRemoved;
        __block RTCallbackTestExpectation *credentialsNotRemoved;
        
        beforeEach(^{
            credentialsRemoved = [RTCallbackTestExpectation noArgsCallbackTestExpectation];
            credentialsNotRemoved = [RTCallbackTestExpectation argsCallbackTextExpectation];
        });
        
        it(@"current username not found", ^{
            stubLoadCurrentUsername(nil);
            
            [dataManager removeLocalCredentialsWithSuccess:anything() failure:credentialsNotRemoved.argsCallback];
            [credentialsNotRemoved expectCallbackExecuted];
            
            NSError *error = credentialsNotRemoved.callbackArguments;
            expect(error).to.beError(RTLogoutErrorDomain, RTLogoutErrorCurrentUsernameNotFound);
        });
        
        it(@"failed to remove token", ^{
            stubLoadCurrentUsername(username);
            stubRemoveTokenForUsername(username, NO);
            
            [dataManager removeLocalCredentialsWithSuccess:anything() failure:credentialsNotRemoved.argsCallback];
            [credentialsNotRemoved expectCallbackExecuted];
            
            NSError *error = credentialsNotRemoved.callbackArguments;
            expect(error).to.beError(RTLogoutErrorDomain, RTLogoutErrorFailedToRemoveStoredToken);
        });
        
        it(@"failed to remove current username", ^{
            stubLoadCurrentUsername(username);

            stubRemoveTokenForUsername(username, YES);
            stubRemoveCurrentUsername(NO);
            
            [dataManager removeLocalCredentialsWithSuccess:anything() failure:credentialsNotRemoved.argsCallback];
            [credentialsNotRemoved expectCallbackExecuted];
            
            NSError *error = credentialsNotRemoved.callbackArguments;
            expect(error).to.beError(RTLogoutErrorDomain, RTLogoutErrorFailedToResetCurrentUser);
        });
        
        it(@"successfully removed local credentials", ^{
            stubLoadCurrentUsername(username);

            stubRemoveTokenForUsername(username, YES);
            stubRemoveCurrentUsername(YES);

            [dataManager removeLocalCredentialsWithSuccess:credentialsRemoved.noArgsCallback failure:anything()];
            [credentialsRemoved expectCallbackExecuted];
        });
    });
});

SpecEnd