#import "RTTestCommon.h"

#import "RTCurrentUserService.h"
#import "RTCurrentUserStore.h"

#import "RTClientCredentials.h"
#import "RTClientCredentialsStore.h"

#import "RTOAuth2Token.h"
#import "RTOAuth2TokenStore.h"

SpecBegin(RTCurrentUserService)

describe(@"current user service", ^{
    
    __block RTCurrentUserService *service;
    
    __block RTCurrentUserStore *currentUserStore;
    __block RTClientCredentialsStore *clientCredentialsStore;
    __block RTOAuth2TokenStore *tokenStore;
 
    __block RTClientCredentials *clientCredentials;
    __block RTOAuth2Token *token;
    
    beforeEach(^{
        clientCredentials = [[RTClientCredentials alloc] initWithClientId:clientId
                                                             clientSecret:clientSecret];
        
        token = [[RTOAuth2Token alloc] init];
        token.accessToken = accessToken;
        token.refreshToken = refreshToken;
        
        currentUserStore = mock([RTCurrentUserStore class]);
        clientCredentialsStore = mock([RTClientCredentialsStore class]);
        tokenStore = mock([RTOAuth2TokenStore class]);
        
        service = [[RTCurrentUserService alloc] initWithCurrentUserStore:currentUserStore
                                                  clientCredentialsStore:clientCredentialsStore
                                                              tokenStore:tokenStore];
    });

    void (^givenNoCurrentUser)() = ^{
        [[given([currentUserStore loadCurrentUsernameWithError:nil]) withMatcher:anything() forArgument:0] willReturn:nil];
    };
    
    void (^givenCurrentUser)() = ^{
        [[given([currentUserStore loadCurrentUsernameWithError:nil]) withMatcher:anything() forArgument:0] willReturn:username];
    };
    
    void (^givenNoClientCredentials)() = ^{
        [[given([clientCredentialsStore loadClientCredentialsForUsername:username error:nil]) withMatcher:anything() forArgument:1]willReturn:nil];
    };
    
    void (^givenClientCredentials)() = ^{
        [[given([clientCredentialsStore loadClientCredentialsForUsername:username error:nil]) withMatcher:anything() forArgument:1]willReturn:clientCredentials];
    };
    
    void (^givenNoToken)() = ^{
        [[given([tokenStore loadTokenForUsername:username error:nil]) withMatcher:anything() forArgument:1]
         willReturn:nil];
    };

    void (^givenToken)() = ^{
        [[given([tokenStore loadTokenForUsername:username error:nil]) withMatcher:anything() forArgument:1]
         willReturn:token];
    };
    
    describe(@"get current username", ^{
        it(@"should return nil if there is no current user", ^{
            givenNoCurrentUser();
            expect([service currentUsername]).to.beNil();
        });
        
        it(@"should return the username of the current user", ^{
            givenCurrentUser();
            expect([service currentUsername]).to.equal(username);
        });
    });
    
    describe(@"get client credentials for current user", ^{
        it(@"should return nil if there is no current user", ^{
            givenNoCurrentUser();
            expect([service clientCredentialsForCurrentUser]).to.beNil();
        });
        
        it(@"should return nil when the current user has no client credentials", ^{
            givenCurrentUser();
            givenNoClientCredentials();
            expect([service clientCredentialsForCurrentUser]).to.beNil();
        });
        
        it(@"should return client credentials for current user", ^{
            givenCurrentUser();
            givenClientCredentials();
            expect([service clientCredentialsForCurrentUser]).to.equal(clientCredentials);
        });
    });
    
    describe(@"get token for current user", ^{
        it(@"should return nil if there is no current user", ^{
            givenNoCurrentUser();
            expect([service tokenForCurrentUser]).to.beNil();
        });
        
        it(@"should return nil when the current user has no token", ^{
            givenCurrentUser();
            givenNoToken();
            expect([service tokenForCurrentUser]).to.beNil();
        });
        
        it(@"should return token for current user", ^{
            givenCurrentUser();
            givenToken();
            expect([service tokenForCurrentUser]).to.equal(token);
        });
    });
});

SpecEnd