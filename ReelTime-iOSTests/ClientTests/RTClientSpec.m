#import "RTTestCommon.h"

#import "RTClient.h"
#import "RTClientErrors.h"
#import "RTClientAssembly.h"

#import "RTRestAPI.h"

#import <Typhoon/Typhoon.h>
#import <Nocilla/Nocilla.h>

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
    
    NSString *(^pathForRawResponseFile)(NSString *) = ^(NSString *filename) {
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        return [bundle pathForResource:filename ofType:@"txt"];
    };
    
    describe(@"requesting a token", ^{
        __block NSRegularExpression *tokenUrlRegex = createUrlRegexForEndpoint(API_TOKEN_ENDPOINT);
        
        it(@"bad client credentials", ^{
            NSString *path = pathForRawResponseFile(@"bad-client-credentials");
            
            stubRequest(@"POST", tokenUrlRegex).
            andReturnRawResponse([NSData dataWithContentsOfFile:path]);
            
            RTClientCredentials *clientCredentials = [[RTClientCredentials alloc] initWithClientId:@"foo"
                                                                                    clientSecret:@"bar"];

            RTUserCredentials *userCredentials = [[RTUserCredentials alloc] initWithUsername:@"buzz"
                                                                                    password:@"bazz"];

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
    });
});

SpecEnd