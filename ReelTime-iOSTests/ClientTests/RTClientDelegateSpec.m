#import "RTTestCommon.h"
#import "RTClientDelegate.h"

#import "RTCurrentUserStore.h"
#import "RTOAuth2TokenStore.h"

#import "RTOAuth2Token.h"

SpecBegin(RTClientDelegate)

describe(@"client delegate", ^{
    __block RTClientDelegate *delegate;
    
    __block RTCurrentUserStore *currentUserStore;
    __block RTOAuth2TokenStore *tokenStore;
    
    beforeEach(^{
        currentUserStore = mock([RTCurrentUserStore class]);
        tokenStore = mock([RTOAuth2TokenStore class]);
        
        delegate = [[RTClientDelegate alloc] initWithCurrentUserStore:currentUserStore
                                                           tokenStore:tokenStore];
    });
    
    describe(@"getting access token for current user", ^{
        __block NSString *accessToken;
        __block RTOAuth2Token *token;
        
        beforeEach(^{
            token = [[RTOAuth2Token alloc] init];
            token.accessToken = @"access-token";
            
            accessToken = nil;
        });

        afterEach(^{
            [verify(currentUserStore) loadCurrentUsernameWithError:nil];
        });
        
        context(@"no user currently logged in", ^{
            beforeEach(^{
                [given([currentUserStore loadCurrentUsernameWithError:nil]) willReturn:nil];
            });
            
            it(@"should return nil for access token", ^{
                accessToken = [delegate accessTokenForCurrentUser];
                expect(accessToken).to.beNil();
            });
        });
        
        context(@"user currently logged in", ^{
            beforeEach(^{
                [given([currentUserStore loadCurrentUsernameWithError:nil]) willReturn:username];
            });
            
            afterEach(^{
                [verify(tokenStore) loadTokenForUsername:username error:nil];
            });
            
            context(@"token not found", ^{
                beforeEach(^{
                    [given([tokenStore loadTokenForUsername:username error:nil]) willReturn:nil];
                });
                
                it(@"should return nil for access token", ^{
                    accessToken = [delegate accessTokenForCurrentUser];
                    expect(accessToken).to.beNil();
                });
            });
            
            context(@"token found", ^{                
                beforeEach(^{
                    RTOAuth2Token *token = [[RTOAuth2Token alloc] init];
                    token.accessToken = @"access-token";
                    
                    [given([tokenStore loadTokenForUsername:username error:nil]) willReturn:token];
                });
                
                it(@"should return access token", ^{
                    accessToken = [delegate accessTokenForCurrentUser];
                    expect(accessToken).to.equal(@"access-token");
                });
            });
        });
    });
});

SpecEnd