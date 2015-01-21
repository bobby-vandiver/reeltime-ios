#import "RTTestCommon.h"

#import "RTClient.h"
#import "RTClientErrors.h"
#import "RTClientAssembly.h"

#import "RTAccountRegistration.h"

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
            clientCredentials = [[RTClientCredentials alloc] initWithClientId:clientId
                                                                 clientSecret:clientSecret];
            
            userCredentials = [[RTUserCredentials alloc] initWithUsername:username
                                                                 password:password];
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
    
    describe(@"requesting account registration", ^{
        __block NSRegularExpression *accountRegistrationUrlRegex = createUrlRegexForEndpoint(API_ACCOUNT_REGISTRATION_ENDPOINT);

        __block RTAccountRegistration *registration;
        
        beforeEach(^{
            registration = [[RTAccountRegistration alloc] initWithUsername:username
                                                                  password:password
                                                      confirmationPassword:password
                                                                     email:email
                                                               displayName:displayName
                                                                clientName:clientName];
        });
        
        it(@"should pass client credentials to callback when successful", ^{
            stubRequest(POST, accountRegistrationUrlRegex).
            andReturnRawResponse(rawResponseFromFile(@"successful-registration"));
            
            waitUntil(^(DoneCallback done) {
                [client registerAccount:registration
                                success:^(RTClientCredentials *clientCredentials) {
                                    expect(clientCredentials.clientId).to.equal(@"5bdee758-cf71-4cd5-9bd9-aded45ce9964");
                                    expect(clientCredentials.clientSecret).to.equal(@"g70mC9ZbpKa6p6R1tJPVWTm55BWHnSkmCv27F=oSI6");
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