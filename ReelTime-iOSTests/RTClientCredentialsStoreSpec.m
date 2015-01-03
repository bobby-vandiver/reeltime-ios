#import "RTTestCommon.h"
#import "RTFakeKeyChainStore.h"

#import "RTClientCredentialsStore.h"

SpecBegin(RTClientCredentialsStore)

describe(@"client credentials store", ^{
    
    __block RTClientCredentialsStore *store;
    __block RTFakeKeyChainStore *keyChainStore;
    
    __block NSString *username = @"someone";
    
    __block NSString *clientId = @"foo";
    __block NSString *clientSecret = @"bar";
    
    beforeEach(^{
        keyChainStore = (RTFakeKeyChainStore *)[UICKeyChainStore keyChainStore];
        store = [[RTClientCredentialsStore alloc] initWithKeyChainStore:keyChainStore];
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

