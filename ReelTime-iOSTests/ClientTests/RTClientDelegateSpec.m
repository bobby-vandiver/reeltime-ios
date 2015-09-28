#import "RTTestCommon.h"
#import "RTAuthenticationAwareHTTPClientDelegate.h"

#import "RTAPIClient.h"
#import "RTCurrentUserService.h"

#import "RTOAuth2Token.h"

SpecBegin(RTClientDelegate)

describe(@"client delegate", ^{
    __block RTAuthenticationAwareHTTPClientDelegate *delegate;
    
    __block RTAPIClient *client;
    __block RTCurrentUserService *currentUserService;
    
    beforeEach(^{
        client = mock([RTAPIClient class]);
        currentUserService = mock([RTCurrentUserService class]);
        
        delegate = [[RTAuthenticationAwareHTTPClientDelegate alloc] initWithAPIClient:client
                                                                   currentUserService:currentUserService];
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