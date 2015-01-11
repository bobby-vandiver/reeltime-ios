#import "RTTestCommon.h"

#import "RTClient.h"
#import "RTClientErrors.h"
#import "RTClientAssembly.h"

#import "RTRestAPI.h"

#import <Typhoon/Typhoon.h>
#import <Nocilla/Nocilla.h>

static NSString *const POST = @"POST";

SpecBegin(RTClient)

describe(@"ReelTime Client", ^{
    
    __block RTClient *client;
    
    beforeAll(^{
        [[LSNocilla sharedInstance] start];
    });
    
    afterAll(^{
        [[LSNocilla sharedInstance] stop];
    });
    
    beforeEach(^{
        RTClientAssembly *assembly = [TyphoonBlockComponentFactory factoryWithAssembly:[RTClientAssembly assembly]];
        client = [assembly reelTimeClient];
    });
    
    afterEach(^{
        [[LSNocilla sharedInstance] clearStubs];
    });

    NSRegularExpression *(^createUrlRegexForEndpoint)(NSString *) = ^(NSString *endpoint) {
        return [NSString stringWithFormat:@"http://(.*?)/%@", endpoint].regex;
    };
    
    NSData *(^rawResponseFromFile)(NSString *) = ^(NSString *filename) {
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        NSString *path = [bundle pathForResource:filename ofType:@"txt"];
        return [NSData dataWithContentsOfFile:path];
    };
    
    describe(@"requesting a token", ^{
        __block NSRegularExpression *tokenUrlRegex = createUrlRegexForEndpoint(API_TOKEN_ENDPOINT);
        
        __block RTClientCredentials *clientCredentials;
        __block RTUserCredentials *userCredentials;
        
        
        beforeEach(^{
            clientCredentials = [[RTClientCredentials alloc] initWithClientId:@"foo"
                                                                 clientSecret:@"bar"];
            
            userCredentials = [[RTUserCredentials alloc] initWithUsername:@"buzz"
                                                                 password:@"bazz"];
        });
        
        it(@"should fail for bad client credentials", ^{
            stubRequest(POST, tokenUrlRegex).
            andReturnRawResponse(rawResponseFromFile(@"bad-client-credentials"));
            
            waitUntil(^(DoneCallback done) {
                [client tokenWithClientCredentials:clientCredentials
                                   userCredentials:userCredentials
                                           success:^(RTOAuth2Token *token) {
                                               fail();
                                               done();
                                           }
                                           failure:^(NSError *error) {
                                               expect(error).to.beError(RTClientTokenErrorDomain, InvalidClientCredentials);
                                               done();
                                           }];
            });
        });
        
        it(@"should fail for bad user credentials", ^{
            stubRequest(POST, tokenUrlRegex).
            andReturnRawResponse(rawResponseFromFile(@"bad-user-credentials"));

            waitUntil(^(DoneCallback done) {
                [client tokenWithClientCredentials:clientCredentials
                                   userCredentials:userCredentials
                                           success:^(RTOAuth2Token *token) {
                                               fail();
                                               done();
                                           }
                                           failure:^(NSError *error) {
                                               expect(error).to.beError(RTClientTokenErrorDomain, InvalidUserCredentials);
                                               done();
                                           }];
            });
        });
        
        it(@"should pass token to callback when successful", ^{
            stubRequest(POST, tokenUrlRegex).
            andReturnRawResponse(rawResponseFromFile(@"successful-token-request"));

            waitUntil(^(DoneCallback done) {
                [client tokenWithClientCredentials:clientCredentials
                                   userCredentials:userCredentials
                                           success:^(RTOAuth2Token *token) {
                                               expect(token.accessToken).to.equal(@"940a0300-ddd7-4302-873c-815a2a6b87ac");
                                               done();
                                           }
                                           failure:^(NSError *error) {
                                               fail();
                                               done();
                                           }];
            });
        });
    });
});

SpecEnd