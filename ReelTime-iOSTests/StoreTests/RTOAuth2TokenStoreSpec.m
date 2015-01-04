#import "RTTestCommon.h"
#import "RTFakeKeyChainWrapper.h"

#import "RTOAuth2TokenStore.h"

SpecBegin(RTOAuth2TokenStore)

describe(@"token store", ^{
    
    __block RTOAuth2TokenStore *store;
    __block RTKeyChainWrapper *keyChainWrapper;
    
    __block NSString *username = @"someone";

    __block NSString *accessToken = @"access";
    __block NSString *refreshToken = @"refresh";
    __block NSString *tokenType = @"bearer";
    __block NSNumber *expiresIn = @12345;
    __block NSString *scope = @"scope";
    
    before(^{
        keyChainWrapper = [[RTFakeKeyChainWrapper alloc] init];
        store = [[RTOAuth2TokenStore alloc] initWithKeyChainWrapper:keyChainWrapper];
    });
    
    context(@"tokens exist in store", ^{
        beforeEach(^{
            RTOAuth2Token *token = [[RTOAuth2Token alloc] init];
            token.accessToken = accessToken;
            token.refreshToken = refreshToken;
            token.tokenType = tokenType;
            token.expiresIn = expiresIn;
            token.scope = scope;
            
            [store storeToken:token forUsername:username error:nil];
        });
        
        it(@"should not find token when the user does not have one", ^{
            RTOAuth2Token *token = [store loadTokenForUsername:username error:nil];
            expect(token).to.beNil;
        });

        it(@"should find token when the user has one", ^{
            RTOAuth2Token *token = [store loadTokenForUsername:username error:nil];
            
            expect(token.accessToken).to.equal(accessToken);
            expect(token.refreshToken).to.equal(refreshToken);
            expect(token.tokenType).to.equal(tokenType);
            expect(token.expiresIn).to.equal(expiresIn);
            expect(token.scope).to.equal(scope);
        });
    });
});

SpecEnd
