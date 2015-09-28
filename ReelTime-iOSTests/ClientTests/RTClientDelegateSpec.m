#import "RTTestCommon.h"
#import "RTAuthenticationAwareHTTPClientDelegate.h"

#import "RTCurrentUserService.h"
#import "RTOAuth2Token.h"

SpecBegin(RTClientDelegate)

describe(@"client delegate", ^{
    __block RTAuthenticationAwareHTTPClientDelegate *delegate;
    
    __block RTCurrentUserService *currentUserService;
    
    beforeEach(^{
        currentUserService = mock([RTCurrentUserService class]);
        delegate = [[RTAuthenticationAwareHTTPClientDelegate alloc] initWithCurrentUserService:currentUserService];
    });
    
    describe(@"getting access token for current user", ^{
        __block RTOAuth2Token *token;
        
        beforeEach(^{
            token = [[RTOAuth2Token alloc] init];
            token.accessToken = @"access-token";

            [given([currentUserService tokenForCurrentUser]) willReturn:token];
        });

        afterEach(^{
            [verify(currentUserService) tokenForCurrentUser];
        });
        
        it(@"should delegate to current user service to get token", ^{
            NSString *accessToken = [delegate accessTokenForCurrentUser];
            expect(accessToken).to.equal(@"access-token");
        });
    });
});

SpecEnd