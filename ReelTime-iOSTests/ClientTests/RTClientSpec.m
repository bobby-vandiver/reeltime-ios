#import "RTTestCommon.h"
#import "RTClientSpecHelper.h"

#import "RTClient.h"
#import "RTAuthenticationAwareHTTPClientDelegate.h"
#import "RTClientAssembly.h"

#import "RTAuthenticationAwareHTTPClient.h"

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

SpecBegin(RTClient)

static NSString *const TEST_ERROR_MESSAGE = @"this is a test";

describe(@"ReelTime Client", ^{
    
    __block RTClient *client;
    __block RTAuthenticationAwareHTTPClientDelegate *delegate;
    
    __block RTClientSpecHelper *helper;

    __block BOOL callbackExecuted;
    __block RTServerErrors *serverErrors;
    
    __block RTUserCredentials *userCredentials;

    beforeAll(^{
        [[LSNocilla sharedInstance] start];
    });
    
    afterAll(^{
        [[LSNocilla sharedInstance] stop];
    });
    
    beforeEach(^{
        helper = [[RTClientSpecHelper alloc] init];

        callbackExecuted = NO;
        serverErrors = nil;
        
        userCredentials = [[RTUserCredentials alloc] initWithUsername:username
                                                             password:password];
        
        RTClientAssembly *assembly = [RTClientAssembly assembly];
        
        TyphoonComponentFactory *factory = [TyphoonBlockComponentFactory factoryWithAssembly:assembly];
        TyphoonPatcher *patcher = [[TyphoonPatcher alloc] init];

        [patcher patchDefinitionWithSelector:@selector(authenticationAwareHTTPClientDelegate) withObject:^id{
            delegate = mock([RTAuthenticationAwareHTTPClientDelegate class]);
            return delegate;
        }];
        
        [factory attachPostProcessor:patcher];
        client = [(RTClientAssembly *)factory reelTimeClient];
    });
    
    afterEach(^{
        [[LSNocilla sharedInstance] clearStubs];
    });
    
    typedef void (^SuccessCallback)(id);
    typedef void (^FailureCallback)(id);

    void (^shouldNotExecute)(DoneCallback) = ^(DoneCallback done) {
        fail();
        done();
    };

    SuccessCallback (^shouldExecuteSuccessCallback)(DoneCallback) = ^SuccessCallback(DoneCallback done) {
        return ^(id obj) {
            callbackExecuted = YES;
            done();
        };
    };
    
    SuccessCallback (^shouldNotExecuteSuccessCallback)(DoneCallback) = ^SuccessCallback(DoneCallback done) {
        return ^(id obj) {
            shouldNotExecute(done);
        };
    };
    
    FailureCallback (^shouldNotExecuteFailureCallback)(DoneCallback) = ^FailureCallback(DoneCallback done) {
        return ^(id obj) {
            expect(obj).to.beKindOf([RTServerErrors class]);
            shouldNotExecute(done);
        };
    };
    
    FailureCallback (^shouldExecuteFailureCallbackWithMessage)(NSString *, DoneCallback) = ^FailureCallback(NSString *expectedError, DoneCallback done) {
        return ^(id obj) {
            expect(obj).to.beKindOf([RTServerErrors class]);
            
            RTServerErrors *serverErrors = (RTServerErrors *)obj;
            expect(serverErrors.errors.count).to.equal(1);
            expect([serverErrors.errors objectAtIndex:0]).to.equal(expectedError);
        };
    };
    
    describe(@"requesting a token", ^{
        __block NSRegularExpression *tokenUrlRegex;
        
        __block RTClientCredentials *clientCredentials;
        
        beforeEach(^{
            tokenUrlRegex = [helper createUrlRegexForEndpoint:API_TOKEN];

            clientCredentials = [[RTClientCredentials alloc] initWithClientId:clientId
                                                                 clientSecret:clientSecret];
        });
        
        it(@"fails due to bad client credentials", ^{
            [helper stubUnauthenticatedRequestWithMethod:POST
                                                urlRegex:tokenUrlRegex
                                     rawResponseFilename:@"token-bad-client-credentials"];
            
            waitUntil(^(DoneCallback done) {
                [client tokenWithClientCredentials:clientCredentials
                                   userCredentials:userCredentials
                                           success:^(RTOAuth2Token *token) {
                                               shouldNotExecute(done);
                                           }
                                           failure:^(RTOAuth2TokenError *error) {
                                               expect(error.errorCode).to.equal(@"invalid_client");
                                               expect(error.errorDescription).to.equal(@"Bad client credentials");
                                               done();
                                           }];
            });
        });
        
        it(@"fails due to bad user credentials", ^{
            [helper stubUnauthenticatedRequestWithMethod:POST
                                                urlRegex:tokenUrlRegex
                                     rawResponseFilename:@"token-bad-user-credentials"];

            waitUntil(^(DoneCallback done) {
                [client tokenWithClientCredentials:clientCredentials
                                   userCredentials:userCredentials
                                           success:^(RTOAuth2Token *token) {
                                               shouldNotExecute(done);
                                           }
                                           failure:^(RTOAuth2TokenError *error) {
                                               expect(error.errorCode).to.equal(@"invalid_grant");
                                               expect(error.errorDescription).to.equal(@"Bad credentials");
                                               done();
                                           }];
            });
        });
        
        it(@"is successful and receives the token", ^{
            [helper stubUnauthenticatedRequestWithMethod:POST
                                                urlRegex:tokenUrlRegex
                                     rawResponseFilename:@"token-successful"];

            waitUntil(^(DoneCallback done) {
                [client tokenWithClientCredentials:clientCredentials
                                   userCredentials:userCredentials
                                           success:^(RTOAuth2Token *token) {
                                               expect(token.accessToken).to.equal(@"940a0300-ddd7-4302-873c-815a2a6b87ac");
                                               done();
                                           }
                                           failure:^(RTOAuth2TokenError *error) {
                                               shouldNotExecute(done);
                                           }];
            });
        });
    });

    describe(@"account registration", ^{
        __block NSRegularExpression *accountRegistrationUrlRegex;

        __block RTAccountRegistration *registration;
        
        beforeEach(^{
            accountRegistrationUrlRegex = [helper createUrlRegexForEndpoint:API_REGISTER_ACCOUNT];
            
            registration = [[RTAccountRegistration alloc] initWithUsername:username
                                                                  password:password
                                                      confirmationPassword:password
                                                                     email:email
                                                               displayName:displayName
                                                                clientName:clientName];
        });
        
        it(@"is successful and receives client credentials", ^{
            [helper stubUnauthenticatedRequestWithMethod:POST
                                                urlRegex:accountRegistrationUrlRegex
                                     rawResponseFilename:@"account-registration-successful"];
            
            waitUntil(^(DoneCallback done) {
                [client registerAccount:registration
                                success:^(RTClientCredentials *clientCredentials) {
                                    expect(clientCredentials.clientId).to.equal(@"5bdee758-cf71-4cd5-9bd9-aded45ce9964");
                                    expect(clientCredentials.clientSecret).to.equal(@"g70mC9ZbpKa6p6R1tJPVWTm55BWHnSkmCv27F=oSI6");
                                    done();
                                }
                                failure:shouldNotExecuteFailureCallback(done)];
            });
        });
        
        it(@"fails with errors", ^{
            [helper stubUnauthenticatedRequestWithMethod:POST
                                                urlRegex:accountRegistrationUrlRegex
                                     rawResponseFilename:@"account-registration-missing-all-params"];
            
            waitUntil(^(DoneCallback done) {
                [client registerAccount:registration
                                success:^(RTClientCredentials *clientCredentials) {
                                    shouldNotExecute(done);
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
        
        it(@"fails due to registration being unavailable", ^{
            [helper stubUnauthenticatedRequestWithMethod:POST
                                                urlRegex:accountRegistrationUrlRegex
                                     rawResponseFilename:@"account-registration-temporarily-unavailable"];
            
            waitUntil(^(DoneCallback done) {
                [client registerAccount:registration
                                success:^(RTClientCredentials *clientCredentials) {
                                    shouldNotExecute(done);
                                }
                                failure:^(RTServerErrors *errors) {
                                    expect(errors.errors.count).to.equal(1);
                                    expect(errors.errors).to.contain(@"Unable to register. Please try again.");
                                    done();
                                }];
            });
        });
    });
    
    describe(@"client registration", ^{
        __block NSRegularExpression *clientRegistrationUrlRegex;
        
        beforeEach(^{
            clientRegistrationUrlRegex = [helper createUrlRegexForEndpoint:API_REGISTER_CLIENT];
        });
        
        it(@"is successful", ^{
            [helper stubUnauthenticatedRequestWithMethod:POST
                                                urlRegex:clientRegistrationUrlRegex
                                     rawResponseFilename:@"client-registration-successful"];
            
            waitUntil(^(DoneCallback done) {
                [client registerClientWithClientName:clientName
                                     userCredentials:userCredentials
                                             success:^(RTClientCredentials *clientCredentials) {
                                                 expect(clientCredentials.clientId).to.equal(@"5bdee758-cf71-4cd5-9bd9-aded45ce9964");
                                                 expect(clientCredentials.clientSecret).to.equal(@"g70mC9ZbpKa6p6R1tJPVWTm55BWHnSkmCv27F=oSI6");
                                                 done();
                                             }
                                             failure:shouldNotExecuteFailureCallback(done)];
            });
        });
        
        xit(@"fails with errors", ^{
            [helper stubUnauthenticatedRequestWithMethod:POST
                                                urlRegex:clientRegistrationUrlRegex
                                     rawResponseFilename:@"bad-request-with-errors"];
            
            waitUntil(^(DoneCallback done) {
                [client registerClientWithClientName:clientName
                                     userCredentials:userCredentials
                                             success:shouldNotExecuteSuccessCallback(done)
                                             failure:shouldExecuteFailureCallbackWithMessage(TEST_ERROR_MESSAGE, done)];
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

        describe(@"account removal", ^{
            __block NSRegularExpression *accountRemovalUrlRegex;
            
            beforeEach(^{
                accountRemovalUrlRegex = [helper createUrlRegexForEndpoint:API_REMOVE_ACCOUNT];
            });
            
            it(@"is successful", ^{
                [helper stubAuthenticatedRequestWithMethod:DELETE
                                                  urlRegex:accountRemovalUrlRegex
                                       rawResponseFilename:@"account-removal-successful"];
                
                waitUntil(^(DoneCallback done) {
                    [client removeAccountWithSuccess:shouldExecuteSuccessCallback(done)
                                             failure:shouldNotExecuteFailureCallback(done)];
                });
                
                expect(callbackExecuted).to.beTruthy();
            });
        });
        
        describe(@"newsfeed", ^{
            __block NSRegularExpression *newsfeedUrlRegex;
            
            beforeEach(^{
                newsfeedUrlRegex = [helper createUrlRegexForEndpoint:API_NEWSFEED];
            });
            
            it(@"is successful and has no activities", ^{
                [helper stubAuthenticatedRequestWithMethod:GET
                                                  urlRegex:newsfeedUrlRegex
                                       rawResponseFilename:@"newsfeed-no-activities"];
                
                waitUntil(^(DoneCallback done) {
                    [client newsfeedPage:1
                                 success:^(RTNewsfeed *newsfeed) {
                                     expect(newsfeed.activities.count).to.equal(0);
                                     done();
                                 }
                                 failure:shouldNotExecuteFailureCallback(done)];
                });
            });
            
            it(@"is successful and has one activity", ^{
                [helper stubAuthenticatedRequestWithMethod:GET
                                                  urlRegex:newsfeedUrlRegex
                                       rawResponseFilename:@"newsfeed-one-activity"];
                
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
                                 failure:shouldNotExecuteFailureCallback(done)];
                });
            });
            
            it(@"is successful and has multiple activities", ^{
                [helper stubAuthenticatedRequestWithMethod:GET
                                                  urlRegex:newsfeedUrlRegex
                                       rawResponseFilename:@"newsfeed-multiple-activities"];
                
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
                                 failure:shouldNotExecuteFailureCallback(done)];
                });
            });
        });
        
        describe(@"join audience", ^{
            __block NSRegularExpression *joinAudienceUrlRegex;
            
            beforeEach(^{
                NSDictionary *pathParams = @{ @":reel_id": @"1" };
                joinAudienceUrlRegex = [helper createUrlRegexForEndpoint:API_ADD_AUDIENCE_MEMBER
                                                          withParameters:pathParams];
            });
            
            it(@"is successful", ^{
                [helper stubAuthenticatedRequestWithMethod:POST
                                                  urlRegex:joinAudienceUrlRegex
                                       rawResponseFilename:@"audience-join-successful"];
                
                waitUntil(^(DoneCallback done) {
                    [client joinAudienceForReelId:1
                                          success:shouldExecuteSuccessCallback(done)
                                          failure:shouldNotExecuteFailureCallback(done)];
                });
                
                expect(callbackExecuted).to.beTruthy();
            });
        });
        
        describe(@"follower user", ^{
            __block NSRegularExpression *followUserUrlRegex;
            
            beforeEach(^{
                NSDictionary *pathParams = @{ @":username": username };
                followUserUrlRegex = [helper createUrlRegexForEndpoint:API_FOLLOW_USER
                                                        withParameters:pathParams];
            });
            
            it(@"is successful", ^{
                [helper stubAuthenticatedRequestWithMethod:POST
                                                  urlRegex:followUserUrlRegex
                                       rawResponseFilename:@"follow-user-successful"];
                
                waitUntil(^(DoneCallback done) {
                    [client followUserForUsername:username
                                          success:shouldExecuteSuccessCallback(done)
                                          failure:shouldNotExecuteFailureCallback(done)];
                });
                
                expect(callbackExecuted).to.beTruthy();
            });
        });
    });
});

SpecEnd