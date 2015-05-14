#import "RTTestCommon.h"

#import "RTCurrentUserService.h"
#import "RTCurrentUserStore.h"

#import "RTClientCredentials.h"
#import "RTClientCredentialsStore.h"

SpecBegin(RTCurrentUserService)

describe(@"current user service", ^{
    
    __block RTCurrentUserService *service;
    
    __block RTCurrentUserStore *currentUserStore;
    __block RTClientCredentialsStore *clientCredentialsStore;

    __block RTClientCredentials *clientCredentials;
    
    beforeEach(^{
        clientCredentials = [[RTClientCredentials alloc] initWithClientId:clientId
                                                             clientSecret:clientSecret];
        
        currentUserStore = mock([RTCurrentUserStore class]);
        clientCredentialsStore = mock([RTClientCredentialsStore class]);
        
        service = [[RTCurrentUserService alloc] initWithCurrentUserStore:currentUserStore
                                                  clientCredentialsStore:clientCredentialsStore];
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
});

SpecEnd