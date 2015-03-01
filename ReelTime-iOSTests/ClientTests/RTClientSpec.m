#import "RTTestCommon.h"
#import "RTClientSpecHelper.h"

#import "RTClient.h"
#import "RTAuthenticationAwareHTTPClientDelegate.h"
#import "RTClientAssembly.h"

#import "RTAuthenticationAwareHTTPClient.h"
#import "RTAuthenticationAwareHTTPClientSpy.h"

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

static NSString *const BAD_REQUEST_ERROR_MESSAGE = @"Bad Request";
static NSString *const SERVICE_UNAVAILABLE_ERROR_MESSAGE = @"Service Unavailable";

static NSString *const BAD_REQUEST_WITH_ERRORS_FILENAME = @"bad-request-with-errors";
static NSString *const FORBIDDEN_WITH_NO_BODY_FILENAME = @"forbidden-with-no-body";

static NSString *const SERVER_INTERNAL_ERROR_FILENAME __attribute__((unused)) = @"server-internal-error";
static NSString *const SERVICE_UNAVAILABLE_WITH_ERRORS_FILENAME = @"service-unavailable-with-errors";

static NSString *const SUCCESSFUL_CREATED_CLIENT_CREDENTIALS_FILENAME = @"successful-created-client-credentials";
static NSString *const SUCCESSFUL_CREATED_WITH_NO_BODY_FILENAME = @"successful-created-with-no-body";
static NSString *const SUCCESSFUL_OK_WITH_NO_BODY_FILENAME = @"successful-ok-with-no-body";

describe(@"ReelTime Client", ^{
    
    __block RTClient *client;
    __block RTAuthenticationAwareHTTPClientDelegate *delegate;
    
    __block RTAuthenticationAwareHTTPClientSpy *httpClient;
    __block RTClientSpecHelper *helper;

    __block BOOL callbackExecuted;
    __block RTServerErrors *serverErrors;
    
    __block RTUserCredentials *userCredentials;
    __block RTClientCredentials *clientCredentials;
    
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
        
        clientCredentials = [[RTClientCredentials alloc] initWithClientId:clientId
                                                             clientSecret:clientSecret];

        RTClientAssembly *assembly = [RTClientAssembly assembly];
        
        TyphoonComponentFactory *factory = [TyphoonBlockComponentFactory factoryWithAssembly:assembly];
        TyphoonPatcher *patcher = [[TyphoonPatcher alloc] init];

        [patcher patchDefinitionWithSelector:@selector(authenticationAwareHTTPClient) withObject:^id{
            RKObjectManager *objectManager = [(RTClientAssembly *)factory restKitObjectManager];
            
            delegate = mock([RTAuthenticationAwareHTTPClientDelegate class]);
            httpClient = [[RTAuthenticationAwareHTTPClientSpy alloc] initWithDelegate:delegate
                                                                 restKitObjectManager:objectManager];
            return httpClient;
        }];
        
        [factory attachPostProcessor:patcher];
        client = [(RTClientAssembly *)factory reelTimeClient];
    });
    
    afterEach(^{
        [[LSNocilla sharedInstance] clearStubs];
    });
    
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
    
    FailureCallback (^shouldExecuteFailureCallbackWithoutMessage)(DoneCallback) = ^FailureCallback(DoneCallback done) {
        return ^(id obj) {
            expect(obj).to.beNil();
            done();
        };
    };
    
    FailureCallback (^shouldExecuteFailureCallbackWithMessage)(NSString *, DoneCallback) = ^FailureCallback(NSString *expectedError, DoneCallback done) {
        return ^(id obj) {
            expect(obj).to.beKindOf([RTServerErrors class]);
            
            RTServerErrors *serverErrors = (RTServerErrors *)obj;
            expect(serverErrors.errors).to.haveCountOf(1);
            expect(serverErrors.errors).to.contain(expectedError);
            
            done();
        };
    };
    
    SuccessCallback (^shouldReceiveClientCredentialsInSuccessfulResponse)(DoneCallback) = ^SuccessCallback(DoneCallback done) {
        return ^(id obj) {
            expect(obj).to.beKindOf([RTClientCredentials class]);
            
            RTClientCredentials *clientCredentials = (RTClientCredentials *)obj;
            expect(clientCredentials.clientId).to.equal(@"5bdee758-cf71-4cd5-9bd9-aded45ce9964");
            expect(clientCredentials.clientSecret).to.equal(@"g70mC9ZbpKa6p6R1tJPVWTm55BWHnSkmCv27F=oSI6");

            done();
        };
    };
    
    describe(@"requesting a token", ^{
        __block NSRegularExpression *tokenUrlRegex;
        
        beforeEach(^{
            tokenUrlRegex = [helper createUrlRegexForEndpoint:API_TOKEN];
        });
        
        afterEach(^{
            expect(httpClient.lastParameters.allKeys).to.haveCountOf(6);
            expect(httpClient.lastParameters[@"grant_type"]).to.equal(@"password");
            expect(httpClient.lastParameters[@"username"]).to.equal(username);
            expect(httpClient.lastParameters[@"password"]).to.equal(password);
            expect(httpClient.lastParameters[@"client_id"]).to.equal(clientId);
            expect(httpClient.lastParameters[@"client_secret"]).to.equal(clientSecret);
            expect(httpClient.lastParameters[@"scope"]).to.equal(@"audiences-read audiences-write reels-read reels-write users-read users-write videos-read videos-write");
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
        
        afterEach(^{
            expect(httpClient.lastParameters.allKeys).to.haveCountOf(5);
            expect(httpClient.lastParameters[@"username"]).to.equal(username);
            expect(httpClient.lastParameters[@"password"]).to.equal(password);
            expect(httpClient.lastParameters[@"email"]).to.equal(email);
            expect(httpClient.lastParameters[@"display_name"]).to.equal(displayName);
            expect(httpClient.lastParameters[@"client_name"]).to.equal(clientName);
        });
        
        it(@"is successful and receives client credentials", ^{
            [helper stubUnauthenticatedRequestWithMethod:POST
                                                urlRegex:accountRegistrationUrlRegex
                                     rawResponseFilename:SUCCESSFUL_CREATED_CLIENT_CREDENTIALS_FILENAME];
            
            waitUntil(^(DoneCallback done) {
                [client registerAccount:registration
                                success:shouldReceiveClientCredentialsInSuccessfulResponse(done)
                                failure:shouldNotExecuteFailureCallback(done)];
            });
        });
        
        it(@"fails with errors", ^{
            [helper stubUnauthenticatedRequestWithMethod:POST
                                                urlRegex:accountRegistrationUrlRegex
                                     rawResponseFilename:BAD_REQUEST_WITH_ERRORS_FILENAME];
            
            waitUntil(^(DoneCallback done) {
                [client registerAccount:registration
                                success:shouldNotExecuteSuccessCallback(done)
                                failure:shouldExecuteFailureCallbackWithMessage(BAD_REQUEST_ERROR_MESSAGE, done)];
            });
        });
        
        it(@"fails due to registration being unavailable", ^{
            [helper stubUnauthenticatedRequestWithMethod:POST
                                                urlRegex:accountRegistrationUrlRegex
                                     rawResponseFilename:SERVICE_UNAVAILABLE_WITH_ERRORS_FILENAME];
            
            waitUntil(^(DoneCallback done) {
                [client registerAccount:registration
                                success:shouldNotExecuteSuccessCallback(done)
                                failure:shouldExecuteFailureCallbackWithMessage(SERVICE_UNAVAILABLE_ERROR_MESSAGE, done)];
            });
        });
    });
    
    describe(@"client registration", ^{
        __block NSRegularExpression *clientRegistrationUrlRegex;
        
        beforeEach(^{
            clientRegistrationUrlRegex = [helper createUrlRegexForEndpoint:API_REGISTER_CLIENT];
        });
        
        afterEach(^{
            expect(httpClient.lastParameters.allKeys).to.haveCountOf(3);
            expect(httpClient.lastParameters[@"username"]).to.equal(username);
            expect(httpClient.lastParameters[@"password"]).to.equal(password);
            expect(httpClient.lastParameters[@"client_name"]).to.equal(clientName);
        });
        
        it(@"is successful", ^{
            [helper stubUnauthenticatedRequestWithMethod:POST
                                                urlRegex:clientRegistrationUrlRegex
                                     rawResponseFilename:SUCCESSFUL_CREATED_CLIENT_CREDENTIALS_FILENAME];
            
            waitUntil(^(DoneCallback done) {
                [client registerClientWithClientName:clientName
                                     userCredentials:userCredentials
                                             success:shouldReceiveClientCredentialsInSuccessfulResponse(done)
                                             failure:shouldNotExecuteFailureCallback(done)];
            });
        });
        
        it(@"fails with bad request errors", ^{
            [helper stubUnauthenticatedRequestWithMethod:POST
                                                urlRegex:clientRegistrationUrlRegex
                                     rawResponseFilename:BAD_REQUEST_WITH_ERRORS_FILENAME];
            
            waitUntil(^(DoneCallback done) {
                [client registerClientWithClientName:clientName
                                     userCredentials:userCredentials
                                             success:shouldNotExecuteSuccessCallback(done)
                                             failure:shouldExecuteFailureCallbackWithMessage(BAD_REQUEST_ERROR_MESSAGE, done)];
            });
        });
        
        it(@"fails due to registration service being unavailable", ^{
            [helper stubUnauthenticatedRequestWithMethod:POST
                                                urlRegex:clientRegistrationUrlRegex
                                     rawResponseFilename:SERVICE_UNAVAILABLE_WITH_ERRORS_FILENAME];
            
            waitUntil(^(DoneCallback done) {
                [client registerClientWithClientName:clientName
                                     userCredentials:userCredentials
                                             success:shouldNotExecuteSuccessCallback(done)
                                             failure:shouldExecuteFailureCallbackWithMessage(SERVICE_UNAVAILABLE_ERROR_MESSAGE, done)];
            });
        });
    });
    
    describe(@"reset password", ^{
        __block NSRegularExpression *resetPasswordUrlRegex;
        __block NSString *resetCode = @"reset";
        
        beforeEach(^{
            resetPasswordUrlRegex = [helper createUrlRegexForEndpoint:API_RESET_PASSWORD];
        });
        
        context(@"known client", ^{
            afterEach(^{
                expect(httpClient.lastParameters.allKeys).to.haveCountOf(6);
                expect(httpClient.lastParameters[@"username"]).to.equal(username);
                expect(httpClient.lastParameters[@"new_password"]).to.equal(password);
                expect(httpClient.lastParameters[@"code"]).to.equal(resetCode);
                expect(httpClient.lastParameters[@"client_is_registered"]).to.beTruthy();
                expect(httpClient.lastParameters[@"client_id"]).to.equal(clientId);
                expect(httpClient.lastParameters[@"client_secret"]).to.equal(clientSecret);
            });
            
            it(@"is successful", ^{
                [helper stubUnauthenticatedRequestWithMethod:POST
                                                    urlRegex:resetPasswordUrlRegex
                                         rawResponseFilename:SUCCESSFUL_OK_WITH_NO_BODY_FILENAME];
                
                waitUntil(^(DoneCallback done) {
                    [client resetPasswordWithCode:resetCode
                                  userCredentials:userCredentials
                                clientCredentials:clientCredentials
                                          success:shouldExecuteSuccessCallback(done)
                                          failure:shouldNotExecuteFailureCallback(done)];
                });
            });
            
            it(@"fails due to bad request", ^{
                [helper stubUnauthenticatedRequestWithMethod:POST
                                                    urlRegex:resetPasswordUrlRegex
                                         rawResponseFilename:BAD_REQUEST_WITH_ERRORS_FILENAME];
                
                waitUntil(^(DoneCallback done) {
                    [client resetPasswordWithCode:resetCode
                                  userCredentials:userCredentials
                                clientCredentials:clientCredentials
                                          success:shouldNotExecuteSuccessCallback(done)
                                          failure:shouldExecuteFailureCallbackWithMessage(BAD_REQUEST_ERROR_MESSAGE, done)];
                });
            });
        });
        
        context(@"unknown client", ^{
            afterEach(^{
                expect(httpClient.lastParameters.allKeys).to.haveCountOf(5);
                expect(httpClient.lastParameters[@"username"]).to.equal(username);
                expect(httpClient.lastParameters[@"new_password"]).to.equal(password);
                expect(httpClient.lastParameters[@"code"]).to.equal(resetCode);
                expect(httpClient.lastParameters[@"client_is_registered"]).to.beFalsy();
                expect(httpClient.lastParameters[@"client_name"]).to.equal(clientName);
            });
            
            it(@"is successful", ^{
                [helper stubUnauthenticatedRequestWithMethod:POST
                                                    urlRegex:resetPasswordUrlRegex
                                         rawResponseFilename:SUCCESSFUL_CREATED_CLIENT_CREDENTIALS_FILENAME];
                
                waitUntil(^(DoneCallback done) {
                    [client resetPasswordWithCode:resetCode
                                  userCredentials:userCredentials
                                       clientName:clientName
                                          success:shouldReceiveClientCredentialsInSuccessfulResponse(done)
                                          failure:shouldNotExecuteFailureCallback(done)];
                });
            });
            
            it(@"fails due to bad request", ^{
                [helper stubUnauthenticatedRequestWithMethod:POST
                                                    urlRegex:resetPasswordUrlRegex
                                         rawResponseFilename:BAD_REQUEST_WITH_ERRORS_FILENAME];
                
                waitUntil(^(DoneCallback done) {
                    [client resetPasswordWithCode:resetCode
                                  userCredentials:userCredentials
                                       clientName:clientName
                                          success:shouldNotExecuteSuccessCallback(done)
                                          failure:shouldExecuteFailureCallbackWithMessage(BAD_REQUEST_ERROR_MESSAGE, done)];
                });
            });
            
            it(@"fails due to service being unavailable", ^{
                [helper stubUnauthenticatedRequestWithMethod:POST
                                                    urlRegex:resetPasswordUrlRegex
                                         rawResponseFilename:SERVICE_UNAVAILABLE_WITH_ERRORS_FILENAME];
                
                waitUntil(^(DoneCallback done) {
                    [client resetPasswordWithCode:resetCode
                                  userCredentials:userCredentials
                                       clientName:clientName
                                          success:shouldNotExecuteSuccessCallback(done)
                                          failure:shouldExecuteFailureCallbackWithMessage(SERVICE_UNAVAILABLE_ERROR_MESSAGE, done)];
                });
            });
        });
    });
    
    describe(@"send reset password email", ^{
        __block NSRegularExpression *sendResetPasswordEmailUrlRegex;
        
        beforeEach(^{
            sendResetPasswordEmailUrlRegex = [helper createUrlRegexForEndpoint:API_RESET_PASSWORD_SEND_EMAIL];
        });
        
        it(@"is successful", ^{
            [helper stubUnauthenticatedRequestWithMethod:POST
                                                urlRegex:sendResetPasswordEmailUrlRegex
                                     rawResponseFilename:SUCCESSFUL_OK_WITH_NO_BODY_FILENAME];
            
            waitUntil(^(DoneCallback done) {
                [client sendResetPasswordEmailWithSuccess:shouldExecuteSuccessCallback(done)
                                                  failure:shouldNotExecuteFailureCallback(done)];
            });
        });
        
        it(@"fails due to service being unavailable", ^{
            [helper stubUnauthenticatedRequestWithMethod:POST
                                                urlRegex:sendResetPasswordEmailUrlRegex
                                     rawResponseFilename:SERVICE_UNAVAILABLE_WITH_ERRORS_FILENAME];
            
            waitUntil(^(DoneCallback done) {
                [client sendResetPasswordEmailWithSuccess:shouldNotExecuteSuccessCallback(done)
                                                  failure:shouldExecuteFailureCallbackWithMessage(SERVICE_UNAVAILABLE_ERROR_MESSAGE, done)];
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
                                       rawResponseFilename:SUCCESSFUL_OK_WITH_NO_BODY_FILENAME];
                
                waitUntil(^(DoneCallback done) {
                    [client removeAccountWithSuccess:shouldExecuteSuccessCallback(done)
                                             failure:shouldNotExecuteFailureCallback(done)];
                });
                
                expect(callbackExecuted).to.beTruthy();
            });
        });
        
        describe(@"client removal", ^{
            __block NSRegularExpression *clientRemovalUrlRegex;
            
            beforeEach(^{
                NSDictionary *parameters = @{ @":client_id": @"clientUUID" };
                clientRemovalUrlRegex = [helper createUrlRegexForEndpoint:API_REMOVE_CLIENT
                                                           withParameters:parameters];
            });
            
            it(@"is successful", ^{
                [helper stubAuthenticatedRequestWithMethod:DELETE
                                                  urlRegex:clientRemovalUrlRegex
                                       rawResponseFilename:SUCCESSFUL_OK_WITH_NO_BODY_FILENAME];
                
                waitUntil(^(DoneCallback done) {
                    [client removeClientWithClientId:@"clientUUID"
                                             success:shouldExecuteSuccessCallback(done)
                                             failure:shouldNotExecuteFailureCallback(done)];
                });
                
                expect(httpClient.lastPath).to.endWith(@"clientUUID");
                expect(httpClient.lastParameters).to.beNil();
            });
        });
        
        describe(@"account confirmation", ^{
            __block NSRegularExpression *accountConfirmationUrlRegex;
            
            beforeEach(^{
                accountConfirmationUrlRegex = [helper createUrlRegexForEndpoint:API_CONFIRM_ACCOUNT];
            });
            
            afterEach(^{
                expect(httpClient.lastParameters.allKeys).to.haveCountOf(1);
                expect(httpClient.lastParameters[@"code"]).to.equal(@"confirmation");
            });
            
            it(@"is successful", ^{
                [helper stubAuthenticatedRequestWithMethod:POST
                                                  urlRegex:accountConfirmationUrlRegex
                                       rawResponseFilename:SUCCESSFUL_OK_WITH_NO_BODY_FILENAME];
                
                waitUntil(^(DoneCallback done) {
                    [client confirmAccountWithCode:@"confirmation"
                                           success:shouldExecuteSuccessCallback(done)
                                           failure:shouldNotExecuteFailureCallback(done)];
                });
            });
            
            it(@"fails due to forbidden request", ^{
                [helper stubAuthenticatedRequestWithMethod:POST
                                                  urlRegex:accountConfirmationUrlRegex
                                       rawResponseFilename:FORBIDDEN_WITH_NO_BODY_FILENAME];
                
                waitUntil(^(DoneCallback done) {
                    [client confirmAccountWithCode:@"confirmation"
                                           success:shouldNotExecuteSuccessCallback(done)
                                           failure:shouldExecuteFailureCallbackWithoutMessage(done)];
                });
            });
        });
        
        describe(@"send account confirmation email", ^{
            __block NSRegularExpression *accountConfirmationEmailUrlRegex;
            
            beforeEach(^{
                accountConfirmationEmailUrlRegex = [helper createUrlRegexForEndpoint:API_CONFIRM_ACCOUNT_SEND_EMAIL];
            });
            
            it(@"is successful", ^{
                [helper stubAuthenticatedRequestWithMethod:POST
                                                  urlRegex:accountConfirmationEmailUrlRegex
                                       rawResponseFilename:SUCCESSFUL_OK_WITH_NO_BODY_FILENAME];
                
                waitUntil(^(DoneCallback done) {
                    [client sendAccountConfirmationEmailWithSuccess:shouldExecuteSuccessCallback(done)
                                                            failure:shouldNotExecuteFailureCallback(done)];
                });
            });
            
            it(@"fails due to service being unavailable", ^{
                [helper stubAuthenticatedRequestWithMethod:POST
                                                  urlRegex:accountConfirmationEmailUrlRegex
                                       rawResponseFilename:SERVICE_UNAVAILABLE_WITH_ERRORS_FILENAME];
                
                waitUntil(^(DoneCallback done) {
                    [client sendAccountConfirmationEmailWithSuccess:shouldNotExecuteSuccessCallback(done)
                                                            failure:shouldExecuteFailureCallbackWithMessage(SERVICE_UNAVAILABLE_ERROR_MESSAGE, done)];
                });
            });
        });
        
        describe(@"change display name", ^{
            __block NSRegularExpression *changeDisplayNameUrlRegex;
            
            beforeEach(^{
                changeDisplayNameUrlRegex = [helper createUrlRegexForEndpoint:API_CHANGE_DISPLAY_NAME];
            });
            
            afterEach(^{
                expect(httpClient.lastParameters.allKeys).to.haveCountOf(1);
                expect(httpClient.lastParameters[@"new_display_name"]).to.equal(displayName);
            });
            
            it(@"is successful", ^{
                [helper stubAuthenticatedRequestWithMethod:POST
                                                  urlRegex:changeDisplayNameUrlRegex
                                       rawResponseFilename:SUCCESSFUL_OK_WITH_NO_BODY_FILENAME];
                
                waitUntil(^(DoneCallback done) {
                    [client changeDisplayName:displayName
                                      success:shouldExecuteSuccessCallback(done)
                                      failure:shouldNotExecuteFailureCallback(done)];
                });
            });
            
            it(@"fails due to bad request", ^{
                [helper stubAuthenticatedRequestWithMethod:POST
                                                  urlRegex:changeDisplayNameUrlRegex
                                       rawResponseFilename:BAD_REQUEST_WITH_ERRORS_FILENAME];
                
                waitUntil(^(DoneCallback done) {
                    [client changeDisplayName:displayName
                                      success:shouldNotExecuteSuccessCallback(done)
                                      failure:shouldExecuteFailureCallbackWithMessage(BAD_REQUEST_ERROR_MESSAGE, done)];
                });
            });
        });
        
        describe(@"change password", ^{
            __block NSRegularExpression *changePasswordUrlRegex;
            
            beforeEach(^{
                changePasswordUrlRegex = [helper createUrlRegexForEndpoint:API_CHANGE_PASSWORD];
            });
            
            afterEach(^{
                expect(httpClient.lastParameters.allKeys).to.haveCountOf(1);
                expect(httpClient.lastParameters[@"new_password"]).to.equal(password);
            });
            
            it(@"is successful", ^{
                [helper stubAuthenticatedRequestWithMethod:POST
                                                  urlRegex:changePasswordUrlRegex
                                       rawResponseFilename:SUCCESSFUL_OK_WITH_NO_BODY_FILENAME];
                
                waitUntil(^(DoneCallback done) {
                    [client changePassword:password
                                   success:shouldExecuteSuccessCallback(done)
                                   failure:shouldNotExecuteFailureCallback(done)];
                });
            });
            
            it(@"fails due to bad request", ^{
                [helper stubAuthenticatedRequestWithMethod:POST
                                                  urlRegex:changePasswordUrlRegex
                                       rawResponseFilename:BAD_REQUEST_WITH_ERRORS_FILENAME];
                
                waitUntil(^(DoneCallback done) {
                    [client changePassword:password
                                   success:shouldNotExecuteSuccessCallback(done)
                                   failure:shouldExecuteFailureCallbackWithMessage(BAD_REQUEST_ERROR_MESSAGE, done)];
                });
            });
        });
        
        describe(@"newsfeed", ^{
            __block NSRegularExpression *newsfeedUrlRegex;
            __block NSUInteger pageNumber = 13;
            
            beforeEach(^{
                newsfeedUrlRegex = [helper createUrlRegexForEndpoint:API_NEWSFEED];
            });
            
            afterEach(^{
                expect(httpClient.lastParameters.allKeys).to.haveCountOf(1);
                expect(httpClient.lastParameters[@"page"]).to.equal(pageNumber);
            });
            
            it(@"is successful and has no activities", ^{
                [helper stubAuthenticatedRequestWithMethod:GET
                                                  urlRegex:newsfeedUrlRegex
                                       rawResponseFilename:@"newsfeed-no-activities"];
                
                waitUntil(^(DoneCallback done) {
                    [client newsfeedPage:pageNumber
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
                    [client newsfeedPage:pageNumber
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
                    [client newsfeedPage:pageNumber
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
                NSDictionary *pathParams = @{ @":reel_id": @"42" };
                joinAudienceUrlRegex = [helper createUrlRegexForEndpoint:API_ADD_AUDIENCE_MEMBER
                                                          withParameters:pathParams];
            });
            
            it(@"is successful", ^{
                [helper stubAuthenticatedRequestWithMethod:POST
                                                  urlRegex:joinAudienceUrlRegex
                                       rawResponseFilename:SUCCESSFUL_CREATED_WITH_NO_BODY_FILENAME];
                
                waitUntil(^(DoneCallback done) {
                    [client joinAudienceForReelId:42
                                          success:shouldExecuteSuccessCallback(done)
                                          failure:shouldNotExecuteFailureCallback(done)];
                });
                
                expect(callbackExecuted).to.beTruthy();
                expect(httpClient.lastPath).to.contain(@"42");
            });
        });
        
        describe(@"follower user", ^{
            __block NSRegularExpression *followUserUrlRegex;
            
            beforeEach(^{
                NSDictionary *pathParams = @{ @":username": username };
                followUserUrlRegex = [helper createUrlRegexForEndpoint:API_FOLLOW_USER
                                                        withParameters:pathParams];
            });
            
            afterEach(^{
                expect(httpClient.lastPath).to.contain(username);
            });
            
            it(@"is successful", ^{
                [helper stubAuthenticatedRequestWithMethod:POST
                                                  urlRegex:followUserUrlRegex
                                       rawResponseFilename:SUCCESSFUL_CREATED_WITH_NO_BODY_FILENAME];
                
                waitUntil(^(DoneCallback done) {
                    [client followUserForUsername:username
                                          success:shouldExecuteSuccessCallback(done)
                                          failure:shouldNotExecuteFailureCallback(done)];
                });
                
                expect(callbackExecuted).to.beTruthy();
                expect(httpClient.lastPath).to.contain(username);
            });
            
            it(@"fails due to bad request", ^{
                [helper stubAuthenticatedRequestWithMethod:POST
                                                  urlRegex:followUserUrlRegex
                                       rawResponseFilename:BAD_REQUEST_WITH_ERRORS_FILENAME];
                
                waitUntil(^(DoneCallback done) {
                    [client followUserForUsername:username
                                          success:shouldNotExecuteSuccessCallback(done)
                                          failure:shouldExecuteFailureCallbackWithMessage(BAD_REQUEST_ERROR_MESSAGE, done)];
                });
            });
        });
    });
});

SpecEnd