#import "RTTestCommon.h"

#import "RTClient.h"
#import "RTClientDelegate.h"
#import "RTClientAssembly.h"

#import "RTClientCredentials.h"
#import "RTUserCredentials.h"

#import "RTOAuth2Token.h"
#import "RTOAuth2TokenError.h"

#import "RTServerErrors.h"

#import "RTAccountRegistration.h"

#import "RTNewsfeed.h"
#import "RTActivity.h"

#import "RTUser.h"
#import "RTReel.h"
#import "RTVideo.h"

#import "RTRestAPI.h"

#import <Typhoon/Typhoon.h>
#import <Typhoon/TyphoonPatcher.h>

#import <Nocilla/Nocilla.h>

static NSString *const GET = @"GET";
static NSString *const POST = @"POST";

static NSString *const AUTHORIZATION = @"Authorization";

static NSString *const ACCESS_TOKEN = @"access-token";
static NSString *const BEARER_TOKEN_AUTHORIZATION_HEADER = @"Bearer access-token";

SpecBegin(RTClient)

describe(@"ReelTime Client", ^{
    
    __block RTClient *client;
    __block RTClientDelegate *delegate;
    
    beforeAll(^{
        [[LSNocilla sharedInstance] start];
    });
    
    afterAll(^{
        [[LSNocilla sharedInstance] stop];
    });
    
    beforeEach(^{
        RTClientAssembly *assembly = [RTClientAssembly assembly];
        
        TyphoonComponentFactory *factory = [TyphoonBlockComponentFactory factoryWithAssembly:assembly];
        TyphoonPatcher *patcher = [[TyphoonPatcher alloc] init];

        [patcher patchDefinitionWithSelector:@selector(reelTimeClientDelegate) withObject:^id{
            delegate = mock([RTClientDelegate class]);
            return delegate;
        }];
        
        [factory attachPostProcessor:patcher];
        client = [(RTClientAssembly *)factory reelTimeClient];
    });
    
    afterEach(^{
        [[LSNocilla sharedInstance] clearStubs];
    });

    NSRegularExpression *(^createUrlRegexForEndpoint)(NSString *) = ^NSRegularExpression *(NSString *endpoint) {
        return [NSString stringWithFormat:@"http://(.*?)/%@", endpoint].regex;
    };
    
    NSRegularExpression *(^createUrlRegexForParameterizedEndpoint)(NSString *, NSDictionary *) = ^NSRegularExpression *(NSString *endpoint,
                                                                                                   NSDictionary *params) {
        NSString *populatedEndpoint = [endpoint copy];
        
        for(NSString *key in [params allKeys]) {
            NSString *value = params[key];
            populatedEndpoint = [populatedEndpoint stringByReplacingOccurrencesOfString:key withString:value];
        }
        
        return createUrlRegexForEndpoint(populatedEndpoint);
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
            andReturnRawResponse(rawResponseFromFile(@"token-bad-client-credentials"));
            
            waitUntil(^(DoneCallback done) {
                [client tokenWithClientCredentials:clientCredentials
                                   userCredentials:userCredentials
                                           success:^(RTOAuth2Token *token) {
                                               fail();
                                               done();
                                           }
                                           failure:^(RTOAuth2TokenError *error) {
                                               expect(error.errorCode).to.equal(@"invalid_client");
                                               expect(error.errorDescription).to.equal(@"Bad client credentials");
                                               done();
                                           }];
            });
        });
        
        it(@"should fail for bad user credentials", ^{
            stubRequest(POST, tokenUrlRegex).
            andReturnRawResponse(rawResponseFromFile(@"token-bad-user-credentials"));

            waitUntil(^(DoneCallback done) {
                [client tokenWithClientCredentials:clientCredentials
                                   userCredentials:userCredentials
                                           success:^(RTOAuth2Token *token) {
                                               fail();
                                               done();
                                           }
                                           failure:^(RTOAuth2TokenError *error) {
                                               expect(error.errorCode).to.equal(@"invalid_grant");
                                               expect(error.errorDescription).to.equal(@"Bad credentials");
                                               done();
                                           }];
            });
        });
        
        it(@"should pass token to callback when successful", ^{
            stubRequest(POST, tokenUrlRegex).
            andReturnRawResponse(rawResponseFromFile(@"token-successful"));

            waitUntil(^(DoneCallback done) {
                [client tokenWithClientCredentials:clientCredentials
                                   userCredentials:userCredentials
                                           success:^(RTOAuth2Token *token) {
                                               expect(token.accessToken).to.equal(@"940a0300-ddd7-4302-873c-815a2a6b87ac");
                                               done();
                                           }
                                           failure:^(RTOAuth2TokenError *error) {
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
            andReturnRawResponse(rawResponseFromFile(@"account-registration-successful"));
            
            waitUntil(^(DoneCallback done) {
                [client registerAccount:registration
                                success:^(RTClientCredentials *clientCredentials) {
                                    expect(clientCredentials.clientId).to.equal(@"5bdee758-cf71-4cd5-9bd9-aded45ce9964");
                                    expect(clientCredentials.clientSecret).to.equal(@"g70mC9ZbpKa6p6R1tJPVWTm55BWHnSkmCv27F=oSI6");
                                    done();
                                }
                                failure:^(RTServerErrors *errors) {
                                    fail();
                                    done();
                                }];
            });
        });
        
        it(@"should pass server errors to failure callback", ^{
            stubRequest(POST, accountRegistrationUrlRegex).
            andReturnRawResponse(rawResponseFromFile(@"account-registration-missing-all-params"));
            
            waitUntil(^(DoneCallback done) {
                [client registerAccount:registration
                                success:^(RTClientCredentials *clientCredentials) {
                                    fail();
                                    done();
                                }
                                failure:^(RTServerErrors *errors) {
                                    expect(errors.errors.count).to.equal(5);
                                    expect(errors.errors).to.contain(@"[email] is required");
                                    expect(errors.errors).to.contain(@"[password] is required");
                                    expect(errors.errors).to.contain(@"[username] is required");
                                    expect(errors.errors).to.contain(@"[display_name] is required");
                                    expect(errors.errors).to.contain(@"[client_name] is required");
                                    done();
                                }];
            });
        });
        
        it(@"should pass registration unavailable error to failure callback", ^{
            stubRequest(POST, accountRegistrationUrlRegex).
            andReturnRawResponse(rawResponseFromFile(@"account-registration-temporarily-unavailable"));
            
            waitUntil(^(DoneCallback done) {
                [client registerAccount:registration
                                success:^(RTClientCredentials *clientCredentials) {
                                    fail();
                                    done();
                                }
                                failure:^(RTServerErrors *errors) {
                                    expect(errors.errors.count).to.equal(1);
                                    expect(errors.errors).to.contain(@"Unable to register. Please try again.");
                                    done();
                                }];
            });
        });
    });
    
    context(@"access token is required and valid", ^{
        beforeEach(^{
            [given([delegate accessTokenForCurrentUser]) willReturn:ACCESS_TOKEN];
        });
        
        afterEach(^{
            [verify(delegate) accessTokenForCurrentUser];
        });
        
        describe(@"newsfeed", ^{
            __block NSRegularExpression *newsfeedUrlRegex = createUrlRegexForEndpoint(API_NEWSFEED_ENDPOINT);

            it(@"should pass newsfeed with no activities to callback", ^{
                stubRequest(GET, newsfeedUrlRegex).
                withHeader(AUTHORIZATION, BEARER_TOKEN_AUTHORIZATION_HEADER).
                andReturnRawResponse(rawResponseFromFile(@"newsfeed-no-activities"));
                
                waitUntil(^(DoneCallback done) {
                    [client newsfeedPage:1
                                 success:^(RTNewsfeed *newsfeed) {
                                     expect(newsfeed.activities.count).to.equal(0);
                                     done();
                                 }
                                 failure:^(RTServerErrors *errors) {
                                     fail();
                                     done();
                                 }];
                });
            });
            
            it(@"should pass newsfeed with one activity to callback", ^{
                stubRequest(GET, newsfeedUrlRegex).
                withHeader(AUTHORIZATION, BEARER_TOKEN_AUTHORIZATION_HEADER).
                andReturnRawResponse(rawResponseFromFile(@"newsfeed-one-activity"));
                
                waitUntil(^(DoneCallback done) {
                    [client newsfeedPage:1
                                 success:^(RTNewsfeed *newsfeed) {
                                     expect(newsfeed.activities.count).to.equal(1);
                                     
                                     RTActivity *activity = [newsfeed.activities objectAtIndex:0];
                                     expect(activity.type).to.equal(RTActivityTypeCreateReel);
                                     
                                     RTUser *user = activity.user;
                                     expect(user).to.beUser(@"someone", @"some display", @(1), @(2));
                                     
                                     RTReel *reel = activity.reel;
                                     expect(reel).to.beReel(@(34), @"some reel", @(901), @(23));
                                     
                                     done();
                                 }
                                 failure:^(RTServerErrors *errors) {
                                     fail();
                                     done();
                                 }];
                });
            });
            
            it(@"should pass newsfeed with multiple activities to callback", ^{
                stubRequest(GET, newsfeedUrlRegex).
                withHeader(AUTHORIZATION, BEARER_TOKEN_AUTHORIZATION_HEADER).
                andReturnRawResponse(rawResponseFromFile(@"newsfeed-multiple-activities"));
                
                waitUntil(^(DoneCallback done) {
                    [client newsfeedPage:1
                                 success:^(RTNewsfeed *newsfeed) {
                                     expect(newsfeed.activities.count).to.equal(3);
                                     
                                     RTActivity *activity = [newsfeed.activities objectAtIndex:0];
                                     expect(activity.type).to.equal(RTActivityTypeCreateReel);
                                     
                                     RTUser *user = activity.user;
                                     expect(user).to.beUser(@"someone", @"some display", @(1), @(2));
                                     
                                     RTReel *reel = activity.reel;
                                     expect(reel).to.beReel(@(34), @"some reel", @(901), @(23));
                                     
                                     activity = [newsfeed.activities objectAtIndex:1];
                                     expect(activity.type).to.equal(RTActivityTypeJoinReelAudience);
                                     
                                     user = activity.user;
                                     expect(user).to.beUser(@"anyone", @"any display", @(6), @(8));
                                     
                                     reel = activity.reel;
                                     expect(reel).to.beReel(@(34), @"some reel", @(901), @(23));
                                     
                                     activity = [newsfeed.activities objectAtIndex:2];
                                     expect(activity.type).to.equal(RTActivityTypeAddVideoToReel);
                                     
                                     user = activity.user;
                                     expect(user).to.beUser(@"someone", @"some display", @(1), @(2));
                                     
                                     reel = activity.reel;
                                     expect(reel).to.beReel(@(34), @"some reel", @(901), @(23));
                                     
                                     RTVideo *video = activity.video;
                                     expect(video).to.beVideo(@(5), @"some video");
                                     
                                     done();
                                 }
                                 failure:^(RTServerErrors *errors) {
                                     fail();
                                     done();
                                 }];
                });
            });
        });
        
        describe(@"join audience", ^{
            __block NSDictionary *pathParams = @{ @":reel_id": @"1" };
            __block NSRegularExpression *joinAudienceUrlRegex = createUrlRegexForParameterizedEndpoint(API_JOIN_REEL_AUDIENCE_ENDPOINT,
                                                                                                       pathParams);
            
            it(@"should execute success callback when audience is joined", ^{
                stubRequest(POST, joinAudienceUrlRegex).
                withHeader(AUTHORIZATION, BEARER_TOKEN_AUTHORIZATION_HEADER).
                andReturnRawResponse(rawResponseFromFile(@"audience-join-successful"));
                
                __block BOOL successCalled = NO;
                
                waitUntil(^(DoneCallback done) {
                    [client joinAudienceForReelId:1
                                          success:^{
                                              successCalled = true;
                                              done();
                                          }
                                          failure:^(RTServerErrors *errors) {
                                              fail();
                                              done();
                                          }];
                });
                
                expect(successCalled).to.beTruthy();
            });
        });
    });
});

SpecEnd