#import "RTTestCommon.h"
#import "RTServerErrorMessageToErrorCodeTestHelper.h"

#import "RTLogoutDataManager.h"
#import "RTAPIClient.h"

#import "RTOAuth2TokenStore.h"
#import "RTCurrentUserStore.h"

#import "RTOAuth2Token.h"

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
    
    describe(@"revoking current token", ^{
        __block RTCallbackTestExpectation *revocationSuccess;
        __block RTCallbackTestExpectation *revocationFailure;

        __block RTOAuth2Token *token;
        
        __block id loadCurrentUsernameMethodCall;
        __block id loadTokenForUsernameMethodCall;
        
        beforeEach(^{
            revocationSuccess = [RTCallbackTestExpectation noArgsCallbackTestExpectation];
            revocationFailure = [RTCallbackTestExpectation argsCallbackTextExpectation];

            loadCurrentUsernameMethodCall = [given([currentUserStore loadCurrentUsernameWithError:nil])
                                             withMatcher:anything() forArgument:0];

            loadTokenForUsernameMethodCall = [given([tokenStore loadTokenForUsername:username error:nil])
                                              withMatcher:anything() forArgument:1];

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
                [loadCurrentUsernameMethodCall willReturn:nil];
                
                [dataManager revokeCurrentTokenWithSuccess:anything() failure:revocationFailure.argsCallback];
                [revocationFailure expectCallbackExecuted];
            });
            
            it(@"token not found", ^{
                [loadCurrentUsernameMethodCall willReturn:username];
                [loadTokenForUsernameMethodCall willReturn:nil];
                
                [dataManager revokeCurrentTokenWithSuccess:anything() failure:revocationFailure.argsCallback];
                [revocationFailure expectCallbackExecuted];
            });
        });

        context(@"local credentials are found", ^{
            beforeEach(^{
                [loadCurrentUsernameMethodCall willReturn:username];
                [loadTokenForUsernameMethodCall willReturn:token];
                
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
        });
    });
});

SpecEnd