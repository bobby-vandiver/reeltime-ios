#import "RTTestCommon.h"
#import "RTClientCredentialsStore.h"

SpecBegin(ClientCredentialsStore)

describe(@"client credentials store", ^{
    
    __block RTClientCredentialsStore *store;
    __block UICKeyChainStore *mockKeyChainStore;
    
    beforeEach(^{
        mockKeyChainStore = mock([UICKeyChainStore class]);
        store = [[RTClientCredentialsStore alloc] initWithKeyChainStore:mockKeyChainStore];
    });
    
    it(@"credentials not found", ^{
        RTClientCredentials *credentials = [store loadClientCredentialsForUsername:@"nobody"];
        expect(credentials).to.beNil;
    });
});

SpecEnd

