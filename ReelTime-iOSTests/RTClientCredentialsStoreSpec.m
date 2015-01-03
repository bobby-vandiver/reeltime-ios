#import "RTTestCommon.h"

#import "RTClientCredentialsStore.h"
#import "RTKeyChainWrapper.h"

SpecBegin(RTClientCredentialsStore)

describe(@"client credentials store", ^{
    
    __block RTClientCredentialsStore *store;
    __block RTKeyChainWrapper *keyChainWrapper;
    
    __block NSString *username = @"someone";
    
    __block NSString *clientId = @"foo";
    __block NSString *clientSecret = @"bar";
    
    beforeEach(^{
        UICKeyChainStore *keyChainStore = [UICKeyChainStore keyChainStore];
        keyChainWrapper = [[RTKeyChainWrapper alloc] initWithKeyChainStore:keyChainStore];
        
        store = [[RTClientCredentialsStore alloc] initWithKeyChainWrapper:keyChainWrapper];
    });
    
    context(@"credentials exist in store", ^{
        beforeEach(^{
            RTClientCredentials *clientCredentials = [[RTClientCredentials alloc] initWithClientId:clientId
                                                                                      clientSecret:clientSecret];
            [store storeClientCredentials:clientCredentials forUsername:username error:nil];
        });
        
        it(@"should not find credentials for a client that is not registered for the user", ^{
            RTClientCredentials *credentials = [store loadClientCredentialsForUsername:@"nobody"];
            expect(credentials).to.beNil;
        });
        
        it(@"should return stored credentials for client registered with the suer", ^{
            RTClientCredentials *credentials = [store loadClientCredentialsForUsername:username];

            expect(credentials.clientId).to.equal(clientId);
            expect(credentials.clientSecret).to.equal(clientSecret);
        });
    });
});

SpecEnd

