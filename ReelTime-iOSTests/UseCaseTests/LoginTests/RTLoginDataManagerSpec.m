#import "RTTestCommon.h"

#import "RTLoginDataManager.h"
#import "RTLoginInteractor.h"
#import "RTLoginInteractor+RTLoginDataManagerDelegate.h"

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

    __block NSString *clientId = @"foo";
    __block NSString *clientSecret = @"bar";
    
    __block NSString *username = @"someone";
    __block NSString *password = @"secret";

    beforeEach(^{
        interactor = mock([RTLoginInteractor class]);

        client = mock([RTClient class]);
        clientCredentialsStore = mock([RTClientCredentialsStore class]);
        
        tokenStore = mock([RTOAuth2TokenStore class]);
        currentUserStore = mock([RTCurrentUserStore class]);
        
        dataManager = [[RTLoginDataManager alloc] initWithInteractor:interactor
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
            
            TokenSuccessHandler successHandler = [successCaptor value];
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
            TokenFailureHandler failureHandler = [failureCaptor value];

            failureHandler(error);
            [verify(interactor) loginDataOperationFailedWithError:error];
        });
    });
});

SpecEnd