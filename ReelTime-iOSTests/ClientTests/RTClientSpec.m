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
    
    describe(@"requesting a token", ^{
        it(@"bad credentials", ^{
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