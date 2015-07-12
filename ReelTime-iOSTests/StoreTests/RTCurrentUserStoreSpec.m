#import "RTTestCommon.h"
#import "RTFakeKeyChainWrapper.h"

#import "RTCurrentUserStore.h"

SpecBegin(RTCurrentUserStore)

describe(@"current user store", ^{
   
    __block RTCurrentUserStore *store;
    __block RTKeyChainWrapper *keyChainWrapper;
    
    before(^{
        keyChainWrapper = [[RTFakeKeyChainWrapper alloc] init];
        store = [[RTCurrentUserStore alloc] initWithKeyChainWrapper:keyChainWrapper];
    });
    
    it(@"should return nil when there is no current user", ^{
        NSString *username = [store loadCurrentUsernameWithError:nil];
        expect(username).to.beNil();
    });
    
    it(@"should return current username", ^{
        BOOL success = [store storeCurrentUsername:@"someone" error:nil];
        expect(success).to.beTruthy();
        
        NSString *username = [store loadCurrentUsernameWithError:nil];
        expect(username).to.equal(@"someone");
    });
    
    it(@"should remove current username", ^{
        BOOL stored = [store storeCurrentUsername:@"someone" error:nil];
        expect(stored).to.beTruthy();
        
        BOOL removed = [store removeCurrentUsernameWithError:nil];
        expect(removed).to.beTruthy();
        
        NSString *username = [store loadCurrentUsernameWithError:nil];
        expect(username).to.beNil();
    });
});

SpecEnd