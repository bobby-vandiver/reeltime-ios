#import "RTTestCommon.h"

#import "RTClientSpecHelper.h"
#import "RTClientSpecCallbackExpectation.h"

#import "RTClientAssembly.h"

#import "RTAPIClient.h"
#import "RTRestAPI.h"

#import "RTAuthenticationAwareHTTPClient.h"
#import "RTAuthenticationAwareHTTPClientSpy.h"
#import "RTAuthenticationAwareHTTPClientDelegate.h"

#import "RTClientCredentials.h"
#import "RTUserCredentials.h"

#import "RTOAuth2Token.h"
#import "RTOAuth2TokenError.h"

#import "RTServerErrors.h"
#import "RTAccountRegistration.h"

#import "RTNewsfeed.h"
#import "RTActivity.h"

#import "RTThumbnail.h"

#import <Typhoon/Typhoon.h>
#import <Typhoon/TyphoonPatcher.h>

#import <RestKit/RestKit.h>
#import <Nocilla/Nocilla.h>

SpecBegin(RTAPIClient)

describe(@"ReelTime Client", ^{
    
    __block RTAPIClient *client;

    __block RTAuthenticationAwareHTTPClientSpy *httpClient;
    __block RTAuthenticationAwareHTTPClientDelegate *delegate;

    __block RTClientSpecHelper *helper;
    __block RTClientSpecCallbackExpectation *callbacks;

    __block RTServerErrors *serverErrors;
    
    __block RTUserCredentials *userCredentials;
    __block RTClientCredentials *clientCredentials;
    
    beforeAll(^{
        [[LSNocilla sharedInstance] start];
    });
    
    beforeEach(^{
        helper = [[RTClientSpecHelper alloc] init];
        callbacks = [[RTClientSpecCallbackExpectation alloc] init];

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
    
    afterAll(^{
        [[LSNocilla sharedInstance] stop];
    });
    
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
            expect(httpClient.lastParameters[@"scope"]).to.equal(@"account-read account-write audiences-read audiences-write reels-read reels-write users-read users-write videos-read videos-write");
        });
        
        it(@"fails due to bad client credentials", ^{
            [helper stubUnauthenticatedRequestWithMethod:POST
                                                urlRegex:tokenUrlRegex
                                     rawResponseFilename:@"token-bad-client-credentials"];
            
            waitUntil(^(DoneCallback done) {
                [client tokenWithClientCredentials:clientCredentials
                                   userCredentials:userCredentials
                                           success:^(RTOAuth2Token *token) {
                                               callbacks.shouldNotExecute(done);
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
                                               callbacks.shouldNotExecute(done);
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
                                               callbacks.shouldNotExecute(done);
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
                                success:callbacks.shouldReceiveClientCredentialsInSuccessfulResponse(done)
                                failure:callbacks.shouldNotExecuteFailureCallback(done)];
            });
        });
        
        it(@"fails with errors", ^{
            [helper stubUnauthenticatedRequestWithMethod:POST
                                                urlRegex:accountRegistrationUrlRegex
                                     rawResponseFilename:BAD_REQUEST_WITH_ERRORS_FILENAME];
            
            waitUntil(^(DoneCallback done) {
                [client registerAccount:registration
                                success:callbacks.shouldNotExecuteSuccessCallback(done)
                                failure:callbacks.shouldExecuteFailureCallbackWithMessage(BAD_REQUEST_ERROR_MESSAGE, done)];
            });
        });
        
        it(@"fails due to registration being unavailable", ^{
            [helper stubUnauthenticatedRequestWithMethod:POST
                                                urlRegex:accountRegistrationUrlRegex
                                     rawResponseFilename:SERVICE_UNAVAILABLE_WITH_ERRORS_FILENAME];
            
            waitUntil(^(DoneCallback done) {
                [client registerAccount:registration
                                success:callbacks.shouldNotExecuteSuccessCallback(done)
                                failure:callbacks.shouldExecuteFailureCallbackWithMessage(SERVICE_UNAVAILABLE_ERROR_MESSAGE, done)];
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
                                             success:callbacks.shouldReceiveClientCredentialsInSuccessfulResponse(done)
                                             failure:callbacks.shouldNotExecuteFailureCallback(done)];
            });
        });
        
        it(@"fails with bad request errors", ^{
            [helper stubUnauthenticatedRequestWithMethod:POST
                                                urlRegex:clientRegistrationUrlRegex
                                     rawResponseFilename:BAD_REQUEST_WITH_ERRORS_FILENAME];
            
            waitUntil(^(DoneCallback done) {
                [client registerClientWithClientName:clientName
                                     userCredentials:userCredentials
                                             success:callbacks.shouldNotExecuteSuccessCallback(done)
                                             failure:callbacks.shouldExecuteFailureCallbackWithMessage(BAD_REQUEST_ERROR_MESSAGE, done)];
            });
        });
        
        it(@"fails due to registration service being unavailable", ^{
            [helper stubUnauthenticatedRequestWithMethod:POST
                                                urlRegex:clientRegistrationUrlRegex
                                     rawResponseFilename:SERVICE_UNAVAILABLE_WITH_ERRORS_FILENAME];
            
            waitUntil(^(DoneCallback done) {
                [client registerClientWithClientName:clientName
                                     userCredentials:userCredentials
                                             success:callbacks.shouldNotExecuteSuccessCallback(done)
                                             failure:callbacks.shouldExecuteFailureCallbackWithMessage(SERVICE_UNAVAILABLE_ERROR_MESSAGE, done)];
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
                                          success:callbacks.shouldExecuteSuccessCallback(done)
                                          failure:callbacks.shouldNotExecuteFailureCallback(done)];
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
                                          success:callbacks.shouldNotExecuteSuccessCallback(done)
                                          failure:callbacks.shouldExecuteFailureCallbackWithMessage(BAD_REQUEST_ERROR_MESSAGE, done)];
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
                                          success:callbacks.shouldReceiveClientCredentialsInSuccessfulResponse(done)
                                          failure:callbacks.shouldNotExecuteFailureCallback(done)];
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
                                          success:callbacks.shouldNotExecuteSuccessCallback(done)
                                          failure:callbacks.shouldExecuteFailureCallbackWithMessage(BAD_REQUEST_ERROR_MESSAGE, done)];
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
                                          success:callbacks.shouldNotExecuteSuccessCallback(done)
                                          failure:callbacks.shouldExecuteFailureCallbackWithMessage(SERVICE_UNAVAILABLE_ERROR_MESSAGE, done)];
                });
            });
        });
    });
    
    describe(@"send reset password email", ^{
        __block NSRegularExpression *sendResetPasswordEmailUrlRegex;
        
        beforeEach(^{
            sendResetPasswordEmailUrlRegex = [helper createUrlRegexForEndpoint:API_RESET_PASSWORD_SEND_EMAIL];
        });
        
        afterEach(^{
            expect(httpClient.lastParameters.allKeys).to.haveACountOf(1);
            expect(httpClient.lastParameters[@"username"]).to.equal(username);
        });
        
        it(@"is successful", ^{
            [helper stubUnauthenticatedRequestWithMethod:POST
                                                urlRegex:sendResetPasswordEmailUrlRegex
                                     rawResponseFilename:SUCCESSFUL_OK_WITH_NO_BODY_FILENAME];
            
            waitUntil(^(DoneCallback done) {
                [client sendResetPasswordEmailForUsername:username
                                                  success:callbacks.shouldExecuteSuccessCallback(done)
                                                  failure:callbacks.shouldNotExecuteFailureCallback(done)];
            });
        });
        
        it(@"fails due to not found", ^{
            [helper stubUnauthenticatedRequestWithMethod:POST
                                                urlRegex:sendResetPasswordEmailUrlRegex
                                     rawResponseFilename:NOT_FOUND_WITH_ERRORS_FILENAME];
            
            waitUntil(^(DoneCallback done) {
                [client sendResetPasswordEmailForUsername:username
                                                  success:callbacks.shouldNotExecuteSuccessCallback(done)
                                                  failure:callbacks.shouldExecuteFailureCallbackWithMessage(NOT_FOUND_ERROR_MESSAGE, done)];
            });
        });
        
        it(@"fails due to service being unavailable", ^{
            [helper stubUnauthenticatedRequestWithMethod:POST
                                                urlRegex:sendResetPasswordEmailUrlRegex
                                     rawResponseFilename:SERVICE_UNAVAILABLE_WITH_ERRORS_FILENAME];
            
            waitUntil(^(DoneCallback done) {
                [client sendResetPasswordEmailForUsername:username
                                                  success:callbacks.shouldNotExecuteSuccessCallback(done)
                                                  failure:callbacks.shouldExecuteFailureCallbackWithMessage(SERVICE_UNAVAILABLE_ERROR_MESSAGE, done)];
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
                    [client removeAccountWithSuccess:callbacks.shouldExecuteSuccessCallback(done)
                                             failure:callbacks.shouldNotExecuteFailureCallback(done)];
                });
            });
            
            it(@"fails due to forbidden", ^{
                [helper stubAuthenticatedRequestWithMethod:DELETE
                                                  urlRegex:accountRemovalUrlRegex
                                       rawResponseFilename:FORBIDDEN_WITH_ERRORS_FILENAME];
                
                waitUntil(^(DoneCallback done) {
                    [client removeAccountWithSuccess:callbacks.shouldNotExecuteSuccessCallback(done)
                                             failure:callbacks.shouldExecuteFailureCallbackWithMessage(FORBIDDEN_ERROR_MESSAGE, done)];
                });
            });
        });
        
        describe(@"list clients", ^{
            __block NSRegularExpression *listClientsUrlRegex;
            
            beforeEach(^{
                listClientsUrlRegex = [helper createUrlRegexForEndpoint:API_LIST_CLIENTS];
            });
            
            afterEach(^{
                expect(httpClient.lastParameters.allKeys).to.haveCountOf(1);
                expect(httpClient.lastParameters[@"page"]).to.equal(pageNumber);
            });
            
            it(@"is successful and has no clients", ^{
                [helper stubAuthenticatedRequestWithMethod:GET
                                                  urlRegex:listClientsUrlRegex
                                       rawResponseFilename:SUCCESSFUL_OK_WITH_CLIENTS_LIST_EMPTY];
                
                waitUntil(^(DoneCallback done) {
                    [client listClientsPage:pageNumber
                                    success:callbacks.shouldReceiveEmptyClientListInSuccessfulResponse(done)
                                    failure:callbacks.shouldNotExecuteFailureCallback(done)];
                });
            });
            
            it(@"is successful and has one client", ^{
                [helper stubAuthenticatedRequestWithMethod:GET
                                                  urlRegex:listClientsUrlRegex
                                       rawResponseFilename:SUCCESSFUL_OK_WITH_CLIENTS_LIST_ONE_CLIENT];
                
                waitUntil(^(DoneCallback done) {
                    [client listClientsPage:pageNumber
                                    success:callbacks.shouldReceiveClientListWithOneClientInSuccessfulResponse(done)
                                    failure:callbacks.shouldNotExecuteFailureCallback(done)];
                });
            });
            
            it(@"is successful and has multiple clients", ^{
                [helper stubAuthenticatedRequestWithMethod:GET
                                                  urlRegex:listClientsUrlRegex
                                       rawResponseFilename:SUCCESSFUL_OK_WITH_CLIENTS_LIST_MULTIPLE_CLIENTS];
                
                waitUntil(^(DoneCallback done) {
                    [client listClientsPage:pageNumber
                                    success:callbacks.shouldReceiveClientListWithMultipleClientsInSuccessfulResponse(done)
                                    failure:callbacks.shouldNotExecuteFailureCallback(done)];
                });
            });
            
            it(@"fails due to bad request", ^{
                [helper stubAuthenticatedRequestWithMethod:GET
                                                  urlRegex:listClientsUrlRegex
                                       rawResponseFilename:BAD_REQUEST_WITH_ERRORS_FILENAME];
                
                waitUntil(^(DoneCallback done) {
                    [client listClientsPage:pageNumber
                                    success:callbacks.shouldNotExecuteSuccessCallback(done)
                                    failure:callbacks.shouldExecuteFailureCallbackWithMessage(BAD_REQUEST_ERROR_MESSAGE, done)];
                });
            });
        });
        
        describe(@"client removal", ^{
            __block NSRegularExpression *clientRemovalUrlRegex;
            
            beforeEach(^{
                NSDictionary *parameters = @{ @":client_id": clientId };
                clientRemovalUrlRegex = [helper createUrlRegexForEndpoint:API_REMOVE_CLIENT
                                                           withParameters:parameters];
            });
            
            afterEach(^{
                expect(httpClient.lastPath).to.endWith(clientId);
                expect(httpClient.lastParameters).to.beNil();
            });
            
            it(@"is successful", ^{
                [helper stubAuthenticatedRequestWithMethod:DELETE
                                                  urlRegex:clientRemovalUrlRegex
                                       rawResponseFilename:SUCCESSFUL_OK_WITH_NO_BODY_FILENAME];
                
                waitUntil(^(DoneCallback done) {
                    [client removeClientWithClientId:clientId
                                             success:callbacks.shouldExecuteSuccessCallback(done)
                                             failure:callbacks.shouldNotExecuteFailureCallback(done)];
                });
            });
            
            it(@"fails due to forbidden", ^{
                [helper stubAuthenticatedRequestWithMethod:DELETE
                                                  urlRegex:clientRemovalUrlRegex
                                       rawResponseFilename:FORBIDDEN_WITH_ERRORS_FILENAME];
                
                waitUntil(^(DoneCallback done) {
                    [client removeClientWithClientId:clientId
                                             success:callbacks.shouldNotExecuteSuccessCallback(done)
                                             failure:callbacks.shouldExecuteFailureCallbackWithMessage(FORBIDDEN_ERROR_MESSAGE, done)];
                });
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
                                           success:callbacks.shouldExecuteSuccessCallback(done)
                                           failure:callbacks.shouldNotExecuteFailureCallback(done)];
                });
            });
            
            it(@"fails due to forbidden request", ^{
                [helper stubAuthenticatedRequestWithMethod:POST
                                                  urlRegex:accountConfirmationUrlRegex
                                       rawResponseFilename:FORBIDDEN_WITH_ERRORS_FILENAME];
                
                waitUntil(^(DoneCallback done) {
                    [client confirmAccountWithCode:@"confirmation"
                                           success:callbacks.shouldNotExecuteSuccessCallback(done)
                                           failure:callbacks.shouldExecuteFailureCallbackWithMessage(FORBIDDEN_ERROR_MESSAGE, done)];
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
                    [client sendAccountConfirmationEmailWithSuccess:callbacks.shouldExecuteSuccessCallback(done)
                                                            failure:callbacks.shouldNotExecuteFailureCallback(done)];
                });
            });
            
            it(@"fails due to service being unavailable", ^{
                [helper stubAuthenticatedRequestWithMethod:POST
                                                  urlRegex:accountConfirmationEmailUrlRegex
                                       rawResponseFilename:SERVICE_UNAVAILABLE_WITH_ERRORS_FILENAME];
                
                waitUntil(^(DoneCallback done) {
                    [client sendAccountConfirmationEmailWithSuccess:callbacks.shouldNotExecuteSuccessCallback(done)
                                                            failure:callbacks.shouldExecuteFailureCallbackWithMessage(SERVICE_UNAVAILABLE_ERROR_MESSAGE, done)];
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
                                      success:callbacks.shouldExecuteSuccessCallback(done)
                                      failure:callbacks.shouldNotExecuteFailureCallback(done)];
                });
            });
            
            it(@"fails due to bad request", ^{
                [helper stubAuthenticatedRequestWithMethod:POST
                                                  urlRegex:changeDisplayNameUrlRegex
                                       rawResponseFilename:BAD_REQUEST_WITH_ERRORS_FILENAME];
                
                waitUntil(^(DoneCallback done) {
                    [client changeDisplayName:displayName
                                      success:callbacks.shouldNotExecuteSuccessCallback(done)
                                      failure:callbacks.shouldExecuteFailureCallbackWithMessage(BAD_REQUEST_ERROR_MESSAGE, done)];
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
                                   success:callbacks.shouldExecuteSuccessCallback(done)
                                   failure:callbacks.shouldNotExecuteFailureCallback(done)];
                });
            });
            
            it(@"fails due to bad request", ^{
                [helper stubAuthenticatedRequestWithMethod:POST
                                                  urlRegex:changePasswordUrlRegex
                                       rawResponseFilename:BAD_REQUEST_WITH_ERRORS_FILENAME];
                
                waitUntil(^(DoneCallback done) {
                    [client changePassword:password
                                   success:callbacks.shouldNotExecuteSuccessCallback(done)
                                   failure:callbacks.shouldExecuteFailureCallbackWithMessage(BAD_REQUEST_ERROR_MESSAGE, done)];
                });
            });
        });
        
        describe(@"newsfeed", ^{
            __block NSRegularExpression *newsfeedUrlRegex;
            
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
                                 failure:callbacks.shouldNotExecuteFailureCallback(done)];
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
                                     expect(user).to.beUser(@"someone", @"some display", @(1), @(2), @(3), @(4), @(YES));
                                     
                                     RTReel *reel = activity.reel;
                                     expect(reel).to.beReel(@(34), @"some reel", @(901), @(23));
                                     
                                     done();
                                 }
                                 failure:callbacks.shouldNotExecuteFailureCallback(done)];
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
                                     expect(user).to.beUser(@"someone", @"some display", @(1), @(2), @(3), @(4), @(YES));
                                     
                                     RTReel *reel = activity.reel;
                                     expect(reel).to.beReel(@(34), @"some reel", @(901), @(23));
                                     
                                     activity = [newsfeed.activities objectAtIndex:1];
                                     expect(activity.type).to.equal(RTActivityTypeJoinReelAudience);
                                     
                                     user = activity.user;
                                     expect(user).to.beUser(@"anyone", @"any display", @(6), @(8), @(10), @(12), @(YES));
                                     
                                     reel = activity.reel;
                                     expect(reel).to.beReel(@(34), @"some reel", @(901), @(23));
                                     
                                     activity = [newsfeed.activities objectAtIndex:2];
                                     expect(activity.type).to.equal(RTActivityTypeAddVideoToReel);
                                     
                                     user = activity.user;
                                     expect(user).to.beUser(@"someone", @"some display", @(1), @(2), @(3), @(4), @(YES));
                                     
                                     reel = activity.reel;
                                     expect(reel).to.beReel(@(34), @"some reel", @(901), @(23));
                                     
                                     RTVideo *video = activity.video;
                                     expect(video).to.beVideo(@(5), @"some video");
                                     
                                     done();
                                 }
                                 failure:callbacks.shouldNotExecuteFailureCallback(done)];
                });
            });
            
            it(@"fails due to bad request", ^{
                [helper stubAuthenticatedRequestWithMethod:GET
                                                  urlRegex:newsfeedUrlRegex
                                       rawResponseFilename:BAD_REQUEST_WITH_ERRORS_FILENAME];

                waitUntil(^(DoneCallback done) {
                    [client newsfeedPage:pageNumber
                                 success:callbacks.shouldNotExecuteSuccessCallback(done)
                                 failure:callbacks.shouldExecuteFailureCallbackWithMessage(BAD_REQUEST_ERROR_MESSAGE, done)];
                });
            });
        });
        
        describe(@"revoke access token", ^{
            __block NSRegularExpression *revokeAccessTokenUrlRegex;
            
            beforeEach(^{
                revokeAccessTokenUrlRegex = [helper createUrlRegexForEndpoint:API_REMOVE_TOKEN];
            });
            
            afterEach(^{
                expect(httpClient.lastParameters.allKeys).to.haveCountOf(1);
                expect(httpClient.lastParameters[@"access_token"]).to.equal(ACCESS_TOKEN);
            });
            
            it(@"is successful", ^{
                [helper stubAuthenticatedRequestWithMethod:POST
                                                  urlRegex:revokeAccessTokenUrlRegex
                                       rawResponseFilename:SUCCESSFUL_OK_WITH_NO_BODY_FILENAME];
                
                waitUntil(^(DoneCallback done) {
                    [client revokeAccessToken:ACCESS_TOKEN
                                      success:callbacks.shouldExecuteSuccessCallback(done)
                                      failure:callbacks.shouldNotExecuteFailureCallback(done)];
                });
            });
            
            it(@"fails due to bad request", ^{
                [helper stubAuthenticatedRequestWithMethod:POST
                                                  urlRegex:revokeAccessTokenUrlRegex
                                       rawResponseFilename:BAD_REQUEST_WITH_ERRORS_FILENAME];
                
                waitUntil(^(DoneCallback done) {
                    [client revokeAccessToken:ACCESS_TOKEN
                                      success:callbacks.shouldNotExecuteSuccessCallback(done)
                                      failure:callbacks.shouldExecuteFailureCallbackWithMessage(BAD_REQUEST_ERROR_MESSAGE, done)];
                });
            });
        });
        
        describe(@"list reels", ^{
            __block NSRegularExpression *listReelsUrlRegex;
            
            beforeEach(^{
                listReelsUrlRegex = [helper createUrlRegexForEndpoint:API_LIST_REELS];
            });
            
            afterEach(^{
                expect(httpClient.lastParameters.allKeys).to.haveCountOf(1);
                expect(httpClient.lastParameters[@"page"]).to.equal(pageNumber);
            });
        
            it(@"is successful and has no reels", ^{
                [helper stubAuthenticatedRequestWithMethod:GET
                                                  urlRegex:listReelsUrlRegex
                                       rawResponseFilename:SUCCESSFUL_OK_WITH_REELS_LIST_EMPTY];
                
                waitUntil(^(DoneCallback done) {
                    [client listReelsPage:pageNumber
                                  success:callbacks.shouldReceiveEmptyReelListInSuccessfulResponse(done)
                                  failure:callbacks.shouldNotExecuteFailureCallback(done)];
                });
            });
            
            it(@"is successful and has one reel", ^{
                [helper stubAuthenticatedRequestWithMethod:GET
                                                  urlRegex:listReelsUrlRegex
                                       rawResponseFilename:SUCCESSFUL_OK_WITH_REELS_LIST_ONE_REEL];
                
                waitUntil(^(DoneCallback done) {
                    [client listReelsPage:pageNumber
                                  success:callbacks.shouldReceiveReelListWithOneReelInSuccessfulResponse(done)
                                  failure:callbacks.shouldNotExecuteFailureCallback(done)];
                });
            });
            
            it(@"is successful and has multiple reels", ^{
                [helper stubAuthenticatedRequestWithMethod:GET
                                                  urlRegex:listReelsUrlRegex
                                       rawResponseFilename:SUCCESSFUL_OK_WITH_REELS_LIST_MULTIPLE_REELS];
                
                waitUntil(^(DoneCallback done) {
                    [client listReelsPage:pageNumber
                                  success:callbacks.shouldReceiveReelListWithMultipleReelsInSuccessfulResponse(done)
                                  failure:callbacks.shouldNotExecuteFailureCallback(done)];
                });
            });
            
            it(@"fails due to bad request", ^{
                [helper stubAuthenticatedRequestWithMethod:GET
                                                  urlRegex:listReelsUrlRegex
                                       rawResponseFilename:BAD_REQUEST_WITH_ERRORS_FILENAME];
                
                waitUntil(^(DoneCallback done) {
                    [client listReelsPage:pageNumber
                                  success:callbacks.shouldNotExecuteSuccessCallback(done)
                                  failure:callbacks.shouldExecuteFailureCallbackWithMessage(BAD_REQUEST_ERROR_MESSAGE, done)];
                });
            });
        });
        
        describe(@"add reel", ^{
            __block NSRegularExpression *addReelUrlRegex;
            __block NSString *reelName = @"something";
            
            beforeEach(^{
                addReelUrlRegex = [helper createUrlRegexForEndpoint:API_ADD_REEL];
            });
            
            afterEach(^{
                expect(httpClient.lastParameters.allKeys).to.haveCountOf(1);
                expect(httpClient.lastParameters[@"name"]).to.equal(reelName);
            });
            
            it(@"is successful", ^{
                [helper stubAuthenticatedRequestWithMethod:POST
                                                  urlRegex:addReelUrlRegex
                                       rawResponseFilename:@"reel-created"];
                
                waitUntil(^(DoneCallback done) {
                    [client addReelWithName:reelName
                                    success:^(RTReel *reel) {
                                        expect(reel).to.beReel(@(749), @"created reel", @(12), @(56));
                                        done();
                                    }
                                    failure:callbacks.shouldNotExecuteFailureCallback(done)];
                });
            });
            
            it(@"fails due to bad request", ^{
                [helper stubAuthenticatedRequestWithMethod:POST
                                                  urlRegex:addReelUrlRegex
                                       rawResponseFilename:BAD_REQUEST_WITH_ERRORS_FILENAME];
                
                waitUntil(^(DoneCallback done) {
                    [client addReelWithName:reelName
                                    success:callbacks.shouldNotExecuteSuccessCallback(done)
                                    failure:callbacks.shouldExecuteFailureCallbackWithMessage(BAD_REQUEST_ERROR_MESSAGE, done)];
                });
            });
        });
        
        context(@"reel_id required in path", ^{
            __block NSMutableDictionary *pathParams;
            
            beforeEach(^{
                pathParams = [NSMutableDictionary dictionary];
                pathParams[@":reel_id"] = [helper stringForUnsignedInteger:reelId];
            });
            
            afterEach(^{
                expect(httpClient.lastPath).to.contain(reelId);
            });
            
            describe(@"get reel", ^{
                __block NSRegularExpression *getReelUrlRegex;
                
                beforeEach(^{
                    getReelUrlRegex = [helper createUrlRegexForEndpoint:API_GET_REEL
                                                         withParameters:pathParams];
                });
                
                it(@"is successful", ^{
                    [helper stubAuthenticatedRequestWithMethod:GET
                                                      urlRegex:getReelUrlRegex
                                           rawResponseFilename:@"single-reel"];
                    
                    waitUntil(^(DoneCallback done) {
                        [client reelForReelId:reelId
                                      success:^(RTReel *reel) {
                                          expect(reel).to.beReel(@(738), @"single reel", @(41), @(123));
                                          done();
                                      }
                                      failure:callbacks.shouldNotExecuteFailureCallback(done)];
                    });
                });
                
                it(@"fails due to not found", ^{
                    [helper stubAuthenticatedRequestWithMethod:GET
                                                      urlRegex:getReelUrlRegex
                                           rawResponseFilename:NOT_FOUND_WITH_ERRORS_FILENAME];
                    
                    waitUntil(^(DoneCallback done) {
                        [client reelForReelId:reelId
                                      success:callbacks.shouldNotExecuteSuccessCallback(done)
                                      failure:callbacks.shouldExecuteFailureCallbackWithMessage(NOT_FOUND_ERROR_MESSAGE, done)];
                    });
                });
            });
            
            describe(@"delete reel", ^{
                __block NSRegularExpression *deleteReelUrlRegex;
                
                beforeEach(^{
                    deleteReelUrlRegex = [helper createUrlRegexForEndpoint:API_DELETE_REEL
                                                            withParameters:pathParams];
                });

                it(@"is successful", ^{
                    [helper stubAuthenticatedRequestWithMethod:DELETE
                                                      urlRegex:deleteReelUrlRegex
                                           rawResponseFilename:SUCCESSFUL_OK_WITH_NO_BODY_FILENAME];
                    
                    waitUntil(^(DoneCallback done) {
                        [client deleteReelForReelId:reelId
                                            success:callbacks.shouldExecuteSuccessCallback(done)
                                            failure:callbacks.shouldNotExecuteFailureCallback(done)];
                    });
                });
                
                it(@"fails due to not found", ^{
                    [helper stubAuthenticatedRequestWithMethod:DELETE
                                                      urlRegex:deleteReelUrlRegex
                                           rawResponseFilename:NOT_FOUND_WITH_ERRORS_FILENAME];
                    
                    waitUntil(^(DoneCallback done) {
                        [client deleteReelForReelId:reelId
                                            success:callbacks.shouldNotExecuteSuccessCallback(done)
                                            failure:callbacks.shouldExecuteFailureCallbackWithMessage(NOT_FOUND_ERROR_MESSAGE, done)];
                    });
                });
                
                it(@"fails due to forbidden", ^{
                    [helper stubAuthenticatedRequestWithMethod:DELETE
                                                      urlRegex:deleteReelUrlRegex
                                           rawResponseFilename:FORBIDDEN_WITH_ERRORS_FILENAME];
                    
                    waitUntil(^(DoneCallback done) {
                        [client deleteReelForReelId:reelId
                                            success:callbacks.shouldNotExecuteSuccessCallback(done)
                                            failure:callbacks.shouldExecuteFailureCallbackWithMessage(FORBIDDEN_ERROR_MESSAGE, done)];
                    });
                });
            });
            
            describe(@"list videos in reel", ^{
                __block NSRegularExpression *listReelVideosUrlRegex;
                
                beforeEach(^{
                    listReelVideosUrlRegex = [helper createUrlRegexForEndpoint:API_LIST_REEL_VIDEOS
                                                                withParameters:pathParams];
                });
                
                afterEach(^{
                    expect(httpClient.lastParameters.allKeys).to.haveCountOf(1);
                    expect(httpClient.lastParameters[@"page"]).to.equal(pageNumber);
                });
                
                it(@"is successful and has no videos", ^{
                    [helper stubAuthenticatedRequestWithMethod:GET
                                                      urlRegex:listReelVideosUrlRegex
                                           rawResponseFilename:SUCCESSFUL_OK_WITH_VIDEOS_LIST_EMPTY];
                    
                    waitUntil(^(DoneCallback done) {
                        [client listVideosPage:pageNumber
                             forReelWithReelId:reelId
                                       success:callbacks.shouldReceiveEmptyVideoListInSuccessfulResponse(done)
                                       failure:callbacks.shouldNotExecuteFailureCallback(done)];
                    });
                });
                
                it(@"is successful and has one video", ^{
                    [helper stubAuthenticatedRequestWithMethod:GET
                                                      urlRegex:listReelVideosUrlRegex
                                           rawResponseFilename:SUCCESSFUL_OK_WITH_VIDEOS_LIST_ONE_VIDEO];
                    
                    waitUntil(^(DoneCallback done) {
                        [client listVideosPage:pageNumber
                             forReelWithReelId:reelId
                                       success:callbacks.shouldReceiveVideoListWithOneVideoInSuccessfulResponse(done)
                                       failure:callbacks.shouldNotExecuteFailureCallback(done)];
                    });
                });
                
                it(@"is successful and has multiple videos", ^{
                    [helper stubAuthenticatedRequestWithMethod:GET
                                                      urlRegex:listReelVideosUrlRegex
                                           rawResponseFilename:SUCCESSFUL_OK_WITH_VIDEOS_LIST_MULTIPLE_VIDEOS];
                    
                    waitUntil(^(DoneCallback done) {
                        [client listVideosPage:pageNumber
                             forReelWithReelId:reelId
                                       success:callbacks.shouldReceiveVideoListWithMultipleVideosInSuccessfulResponse(done)
                                       failure:callbacks.shouldNotExecuteFailureCallback(done)];
                    });
                });
                
                it(@"fails due to bad request", ^{
                    [helper stubAuthenticatedRequestWithMethod:GET
                                                      urlRegex:listReelVideosUrlRegex
                                           rawResponseFilename:BAD_REQUEST_WITH_ERRORS_FILENAME];
                    
                    waitUntil(^(DoneCallback done) {
                        [client listVideosPage:pageNumber
                             forReelWithReelId:reelId
                                       success:callbacks.shouldNotExecuteSuccessCallback(done)
                                       failure:callbacks.shouldExecuteFailureCallbackWithMessage(BAD_REQUEST_ERROR_MESSAGE, done)];
                    });
                });
                
                it(@"fails due to not found", ^{
                    [helper stubAuthenticatedRequestWithMethod:GET
                                                      urlRegex:listReelVideosUrlRegex
                                           rawResponseFilename:NOT_FOUND_WITH_ERRORS_FILENAME];
                    
                    waitUntil(^(DoneCallback done) {
                        [client listVideosPage:pageNumber
                             forReelWithReelId:reelId
                                       success:callbacks.shouldNotExecuteSuccessCallback(done)
                                       failure:callbacks.shouldExecuteFailureCallbackWithMessage(NOT_FOUND_ERROR_MESSAGE, done)];
                    });
                });
            });
            
            describe(@"add video to reel", ^{
                __block NSRegularExpression *addVideoToReelUrlRegex;
                
                beforeEach(^{
                    addVideoToReelUrlRegex = [helper createUrlRegexForEndpoint:API_ADD_REEL_VIDEO
                                                                withParameters:pathParams];
                });
                
                afterEach(^{
                    expect(httpClient.lastParameters.allKeys).to.haveCountOf(1);
                    expect(httpClient.lastParameters[@"video_id"]).to.equal(videoId);
                });
                
                it(@"is successful", ^{
                    [helper stubAuthenticatedRequestWithMethod:POST
                                                      urlRegex:addVideoToReelUrlRegex
                                           rawResponseFilename:SUCCESSFUL_CREATED_WITH_NO_BODY_FILENAME];
                    
                    waitUntil(^(DoneCallback done) {
                        [client addVideoWithVideoId:videoId
                                   toReelWithReelId:reelId
                                            success:callbacks.shouldExecuteSuccessCallback(done)
                                            failure:callbacks.shouldNotExecuteFailureCallback(done)];
                    });
                });
                
                it(@"fails due to forbidden", ^{
                    [helper stubAuthenticatedRequestWithMethod:POST
                                                      urlRegex:addVideoToReelUrlRegex
                                           rawResponseFilename:FORBIDDEN_WITH_ERRORS_FILENAME];
                    
                    waitUntil(^(DoneCallback done) {
                        [client addVideoWithVideoId:videoId
                                   toReelWithReelId:reelId
                                            success:callbacks.shouldNotExecuteSuccessCallback(done)
                                            failure:callbacks.shouldExecuteFailureCallbackWithMessage(FORBIDDEN_ERROR_MESSAGE, done)];
                    });
                });
                
                it(@"fails due to not found", ^{
                    [helper stubAuthenticatedRequestWithMethod:POST
                                                      urlRegex:addVideoToReelUrlRegex
                                           rawResponseFilename:NOT_FOUND_WITH_ERRORS_FILENAME];
                    
                    waitUntil(^(DoneCallback done) {
                        [client addVideoWithVideoId:videoId
                                   toReelWithReelId:reelId
                                            success:callbacks.shouldNotExecuteSuccessCallback(done)
                                            failure:callbacks.shouldExecuteFailureCallbackWithMessage(NOT_FOUND_ERROR_MESSAGE, done)];
                    });
                });
            });
            
            describe(@"remove video from reel", ^{
                __block NSRegularExpression *removeVideoFromReelUrlRegex;
                
                beforeEach(^{
                    pathParams[@":video_id"] = [helper stringForUnsignedInteger:videoId];
                    removeVideoFromReelUrlRegex = [helper createUrlRegexForEndpoint:API_REMOVE_REEL_VIDEO
                                                                     withParameters:pathParams];
                });
                
                afterEach(^{
                    expect(httpClient.lastPath).to.contain(videoId);
                });
                
                it(@"is successful", ^{
                    [helper stubAuthenticatedRequestWithMethod:DELETE
                                                      urlRegex:removeVideoFromReelUrlRegex
                                           rawResponseFilename:SUCCESSFUL_OK_WITH_NO_BODY_FILENAME];
                    
                    waitUntil(^(DoneCallback done) {
                        [client removeVideoWithVideoId:videoId
                                    fromReelWithReelId:reelId
                                               success:callbacks.shouldExecuteSuccessCallback(done)
                                               failure:callbacks.shouldNotExecuteFailureCallback(done)];
                    });
                });
                
                it(@"fails due to forbidden", ^{
                    [helper stubAuthenticatedRequestWithMethod:DELETE
                                                      urlRegex:removeVideoFromReelUrlRegex
                                           rawResponseFilename:FORBIDDEN_WITH_ERRORS_FILENAME];
                    
                    waitUntil(^(DoneCallback done) {
                        [client removeVideoWithVideoId:videoId
                                    fromReelWithReelId:reelId
                                               success:callbacks.shouldNotExecuteSuccessCallback(done)
                                               failure:callbacks.shouldExecuteFailureCallbackWithMessage(FORBIDDEN_ERROR_MESSAGE, done)];
                    });
                });
                
                it(@"fails due to not found", ^{
                    [helper stubAuthenticatedRequestWithMethod:DELETE
                                                      urlRegex:removeVideoFromReelUrlRegex
                                           rawResponseFilename:NOT_FOUND_WITH_ERRORS_FILENAME];
                    
                    waitUntil(^(DoneCallback done) {
                        [client removeVideoWithVideoId:videoId
                                    fromReelWithReelId:reelId
                                               success:callbacks.shouldNotExecuteSuccessCallback(done)
                                               failure:callbacks.shouldExecuteFailureCallbackWithMessage(NOT_FOUND_ERROR_MESSAGE, done)];
                    });
                });
            });
            
            describe(@"list audience members", ^{
                __block NSRegularExpression *listAudienceUrlRegex;
                
                beforeEach(^{
                    listAudienceUrlRegex = [helper createUrlRegexForEndpoint:API_LIST_AUDIENCE_MEMBERS
                                                              withParameters:pathParams];
                });
                afterEach(^{
                    expect(httpClient.lastParameters.allKeys).to.haveCountOf(1);
                    expect(httpClient.lastParameters[@"page"]).to.equal(pageNumber);
                });
                
                it(@"is successful and has no members", ^{
                    [helper stubAuthenticatedRequestWithMethod:GET
                                                      urlRegex:listAudienceUrlRegex
                                           rawResponseFilename:SUCCESSFUL_OK_WITH_USERS_LIST_EMPTY];
                    
                    waitUntil(^(DoneCallback done) {
                        [client listAudienceMembersPage:pageNumber
                                      forReelWithReelId:reelId
                                                success:callbacks.shouldReceiveEmptyUserListInSuccessfulResponse(done)
                                                failure:callbacks.shouldNotExecuteFailureCallback(done)];
                    });
                });
                
                it(@"is successful and has one member", ^{
                    [helper stubAuthenticatedRequestWithMethod:GET
                                                      urlRegex:listAudienceUrlRegex
                                           rawResponseFilename:SUCCESSFUL_OK_WITH_USERS_LIST_ONE_USER];
                    
                    waitUntil(^(DoneCallback done) {
                        [client listAudienceMembersPage:pageNumber
                                      forReelWithReelId:reelId
                                                success:callbacks.shouldReceiveUserListWithOneUserInSuccessfulResponse(done)
                                                failure:callbacks.shouldNotExecuteFailureCallback(done)];
                    });
                });
                
                it(@"is successful and has multiple members", ^{
                    [helper stubAuthenticatedRequestWithMethod:GET
                                                      urlRegex:listAudienceUrlRegex
                                           rawResponseFilename:SUCCESSFUL_OK_WITH_USERS_LIST_MULTIPLE_USERS];
                    
                    waitUntil(^(DoneCallback done) {
                        [client listAudienceMembersPage:pageNumber
                                      forReelWithReelId:reelId
                                                success:callbacks.shouldReceiveUserListWithMultipleUsersInSuccessfulResponse(done)
                                                failure:callbacks.shouldNotExecuteFailureCallback(done)];
                    });
                });
                
                it(@"fails due to bad request", ^{
                    [helper stubAuthenticatedRequestWithMethod:GET
                                                      urlRegex:listAudienceUrlRegex
                                           rawResponseFilename:BAD_REQUEST_WITH_ERRORS_FILENAME];
                    
                    waitUntil(^(DoneCallback done) {
                        [client listAudienceMembersPage:pageNumber
                                      forReelWithReelId:reelId
                                                success:callbacks.shouldNotExecuteSuccessCallback(done)
                                                failure:callbacks.shouldExecuteFailureCallbackWithMessage(BAD_REQUEST_ERROR_MESSAGE, done)];
                    });
                });
                
                it(@"fails due to not found", ^{
                    [helper stubAuthenticatedRequestWithMethod:GET
                                                      urlRegex:listAudienceUrlRegex
                                           rawResponseFilename:NOT_FOUND_WITH_ERRORS_FILENAME];
                    
                    waitUntil(^(DoneCallback done) {
                        [client listAudienceMembersPage:pageNumber
                                      forReelWithReelId:reelId
                                                success:callbacks.shouldNotExecuteSuccessCallback(done)
                                                failure:callbacks.shouldExecuteFailureCallbackWithMessage(NOT_FOUND_ERROR_MESSAGE, done)];
                    });
                });
            });
            
            describe(@"join audience", ^{
                __block NSRegularExpression *joinAudienceUrlRegex;
                
                beforeEach(^{
                    joinAudienceUrlRegex = [helper createUrlRegexForEndpoint:API_ADD_AUDIENCE_MEMBER
                                                              withParameters:pathParams];
                });
                
                it(@"is successful", ^{
                    [helper stubAuthenticatedRequestWithMethod:POST
                                                      urlRegex:joinAudienceUrlRegex
                                           rawResponseFilename:SUCCESSFUL_CREATED_WITH_NO_BODY_FILENAME];
                    
                    waitUntil(^(DoneCallback done) {
                        [client joinAudienceForReelWithReelId:reelId
                                                      success:callbacks.shouldExecuteSuccessCallback(done)
                                                      failure:callbacks.shouldNotExecuteFailureCallback(done)];
                    });
                });
                
                it(@"fails due to forbidden", ^{
                    [helper stubAuthenticatedRequestWithMethod:POST
                                                      urlRegex:joinAudienceUrlRegex
                                           rawResponseFilename:FORBIDDEN_WITH_ERRORS_FILENAME];
                    
                    waitUntil(^(DoneCallback done) {
                        [client joinAudienceForReelWithReelId:reelId
                                                      success:callbacks.shouldNotExecuteSuccessCallback(done)
                                                      failure:callbacks.shouldExecuteFailureCallbackWithMessage(FORBIDDEN_ERROR_MESSAGE, done)];
                    });
                });
                
                it(@"fails due to not found", ^{
                    [helper stubAuthenticatedRequestWithMethod:POST
                                                      urlRegex:joinAudienceUrlRegex
                                           rawResponseFilename:NOT_FOUND_WITH_ERRORS_FILENAME];
                    
                    waitUntil(^(DoneCallback done) {
                        [client joinAudienceForReelWithReelId:reelId
                                                      success:callbacks.shouldNotExecuteSuccessCallback(done)
                                                      failure:callbacks.shouldExecuteFailureCallbackWithMessage(NOT_FOUND_ERROR_MESSAGE, done)];
                    });
                });
            });
            
            describe(@"leaving audience", ^{
                __block NSRegularExpression *leaveAudienceUrlRegex;
                
                beforeEach(^{
                    leaveAudienceUrlRegex = [helper createUrlRegexForEndpoint:API_REMOVE_AUDIENCE_MEMBER
                                                               withParameters:pathParams];
                });
                
                it(@"is successful", ^{
                    [helper stubAuthenticatedRequestWithMethod:DELETE
                                                      urlRegex:leaveAudienceUrlRegex
                                           rawResponseFilename:SUCCESSFUL_OK_WITH_NO_BODY_FILENAME];
                    
                    waitUntil(^(DoneCallback done) {
                        [client leaveAudienceForReelWithReelId:reelId
                                                       success:callbacks.shouldExecuteSuccessCallback(done)
                                                       failure:callbacks.shouldNotExecuteFailureCallback(done)];
                    });
                });
                
                it(@"fails due to not found", ^{
                    [helper stubAuthenticatedRequestWithMethod:DELETE
                                                      urlRegex:leaveAudienceUrlRegex
                                           rawResponseFilename:NOT_FOUND_WITH_ERRORS_FILENAME];
                    
                    waitUntil(^(DoneCallback done) {
                        [client leaveAudienceForReelWithReelId:reelId
                                                       success:callbacks.shouldNotExecuteSuccessCallback(done)
                                                       failure:callbacks.shouldExecuteFailureCallbackWithMessage(NOT_FOUND_ERROR_MESSAGE, done)];
                    });
                });
                
                it(@"fails due to forbidden", ^{
                    [helper stubAuthenticatedRequestWithMethod:DELETE
                                                      urlRegex:leaveAudienceUrlRegex
                                           rawResponseFilename:FORBIDDEN_WITH_ERRORS_FILENAME];
                    
                    waitUntil(^(DoneCallback done) {
                        [client leaveAudienceForReelWithReelId:reelId
                                                       success:callbacks.shouldNotExecuteSuccessCallback(done)
                                                       failure:callbacks.shouldExecuteFailureCallbackWithMessage(FORBIDDEN_ERROR_MESSAGE, done)];
                    });
                });
            });
        });
        
        describe(@"list users", ^{
            __block NSRegularExpression *listUsersUrlRegex;
            
            beforeEach(^{
                listUsersUrlRegex = [helper createUrlRegexForEndpoint:API_LIST_USERS];
            });
            
            afterEach(^{
                expect(httpClient.lastParameters.allKeys).to.haveCountOf(1);
                expect(httpClient.lastParameters[@"page"]).to.equal(pageNumber);
            });
            
            it(@"is successful and has no users", ^{
                [helper stubAuthenticatedRequestWithMethod:GET
                                                  urlRegex:listUsersUrlRegex
                                       rawResponseFilename:SUCCESSFUL_OK_WITH_USERS_LIST_EMPTY];
                
                waitUntil(^(DoneCallback done) {
                    [client listUsersPage:pageNumber
                                  success:callbacks.shouldReceiveEmptyUserListInSuccessfulResponse(done)
                                  failure:callbacks.shouldNotExecuteFailureCallback(done)];
                });
            });
            
            it(@"is successful and has one user", ^{
                [helper stubAuthenticatedRequestWithMethod:GET
                                                  urlRegex:listUsersUrlRegex
                                       rawResponseFilename:SUCCESSFUL_OK_WITH_USERS_LIST_ONE_USER];
                
                waitUntil(^(DoneCallback done) {
                    [client listUsersPage:pageNumber
                                  success:callbacks.shouldReceiveUserListWithOneUserInSuccessfulResponse(done)
                                  failure:callbacks.shouldNotExecuteFailureCallback(done)];
                });
            });
            
            it(@"is successful and has multiple users", ^{
                [helper stubAuthenticatedRequestWithMethod:GET
                                                  urlRegex:listUsersUrlRegex
                                       rawResponseFilename:SUCCESSFUL_OK_WITH_USERS_LIST_MULTIPLE_USERS];
                
                waitUntil(^(DoneCallback done) {
                    [client listUsersPage:pageNumber
                                  success:callbacks.shouldReceiveUserListWithMultipleUsersInSuccessfulResponse(done)
                                  failure:callbacks.shouldNotExecuteFailureCallback(done)];
                });
            });
            
            it(@"fails due to bad request", ^{
                [helper stubAuthenticatedRequestWithMethod:GET
                                                  urlRegex:listUsersUrlRegex
                                       rawResponseFilename:BAD_REQUEST_WITH_ERRORS_FILENAME];
                
                waitUntil(^(DoneCallback done) {
                    [client listUsersPage:pageNumber
                                  success:callbacks.shouldNotExecuteSuccessCallback(done)
                                  failure:callbacks.shouldExecuteFailureCallbackWithMessage(BAD_REQUEST_ERROR_MESSAGE, done)];
                });
            });
        });
        
        context(@"username required in path", ^{
            NSDictionary *pathParams = @{ @":username": username };
            
            afterEach(^{
                expect(httpClient.lastPath).to.contain(username);
            });
            
            describe(@"get user", ^{
                __block NSRegularExpression *getUserUrlRegex;
                
                beforeEach(^{
                    getUserUrlRegex = [helper createUrlRegexForEndpoint:API_GET_USER
                                                         withParameters:pathParams];
                });
                
                it(@"is successful", ^{
                    [helper stubAuthenticatedRequestWithMethod:GET
                                                      urlRegex:getUserUrlRegex
                                           rawResponseFilename:@"single-user"];
                    
                    waitUntil(^(DoneCallback done) {
                        [client userForUsername:username
                                        success:^(RTUser *user) {
                                            expect(user).to.beUser(@"alone", @"all alone", @(123), @(95), @(42), @(31), @(YES));
                                            done();
                                        }
                                        failure:callbacks.shouldNotExecuteFailureCallback(done)];
                    });
                });
                
                it(@"fails due to not found", ^{
                    [helper stubAuthenticatedRequestWithMethod:GET
                                                      urlRegex:getUserUrlRegex
                                           rawResponseFilename:NOT_FOUND_WITH_ERRORS_FILENAME];
                    
                    waitUntil(^(DoneCallback done) {
                        [client userForUsername:username
                                        success:callbacks.shouldNotExecuteSuccessCallback(done)
                                        failure:callbacks.shouldExecuteFailureCallbackWithMessage(NOT_FOUND_ERROR_MESSAGE, done)];
                    });
                });
            });
            
            describe(@"list user reels", ^{
                __block NSRegularExpression *listUserReelsUrlRegex;
                
                beforeEach(^{
                    listUserReelsUrlRegex = [helper createUrlRegexForEndpoint:API_LIST_USER_REELS
                                                               withParameters:pathParams];
                });
                
                afterEach(^{
                    expect(httpClient.lastParameters.allKeys).to.haveCountOf(1);
                    expect(httpClient.lastParameters[@"page"]).to.equal(pageNumber);
                });
                
                it(@"is successful and has no reels", ^{
                    [helper stubAuthenticatedRequestWithMethod:GET
                                                      urlRegex:listUserReelsUrlRegex
                                           rawResponseFilename:SUCCESSFUL_OK_WITH_REELS_LIST_EMPTY];
                    
                    waitUntil(^(DoneCallback done) {
                        [client listReelsPage:pageNumber
                          forUserWithUsername:username
                                      success:callbacks.shouldReceiveEmptyReelListInSuccessfulResponse(done)
                                      failure:callbacks.shouldNotExecuteFailureCallback(done)];
                    });
                });
                
                it(@"fails due to bad request", ^{
                    [helper stubAuthenticatedRequestWithMethod:GET
                                                      urlRegex:listUserReelsUrlRegex
                                           rawResponseFilename:BAD_REQUEST_WITH_ERRORS_FILENAME];
                    
                    waitUntil(^(DoneCallback done) {
                        [client listReelsPage:pageNumber
                          forUserWithUsername:username
                                      success:callbacks.shouldNotExecuteSuccessCallback(done)
                                      failure:callbacks.shouldExecuteFailureCallbackWithMessage(BAD_REQUEST_ERROR_MESSAGE, done)];
                    });
                });
                
                it(@"fails due to not found", ^{
                    [helper stubAuthenticatedRequestWithMethod:GET
                                                      urlRegex:listUserReelsUrlRegex
                                           rawResponseFilename:NOT_FOUND_WITH_ERRORS_FILENAME];
                    
                    waitUntil(^(DoneCallback done) {
                        [client listReelsPage:pageNumber
                          forUserWithUsername:username
                                      success:callbacks.shouldNotExecuteSuccessCallback(done)
                                      failure:callbacks.shouldExecuteFailureCallbackWithMessage(NOT_FOUND_ERROR_MESSAGE, done)];
                    });
                });
            });
            
            describe(@"follow user", ^{
                __block NSRegularExpression *followUserUrlRegex;
                
                beforeEach(^{
                    followUserUrlRegex = [helper createUrlRegexForEndpoint:API_FOLLOW_USER
                                                            withParameters:pathParams];
                });
                
                it(@"is successful", ^{
                    [helper stubAuthenticatedRequestWithMethod:POST
                                                      urlRegex:followUserUrlRegex
                                           rawResponseFilename:SUCCESSFUL_CREATED_WITH_NO_BODY_FILENAME];
                    
                    waitUntil(^(DoneCallback done) {
                        [client followUserForUsername:username
                                              success:callbacks.shouldExecuteSuccessCallback(done)
                                              failure:callbacks.shouldNotExecuteFailureCallback(done)];
                    });
                });
                
                it(@"fails due to forbidden", ^{
                    [helper stubAuthenticatedRequestWithMethod:POST
                                                      urlRegex:followUserUrlRegex
                                           rawResponseFilename:FORBIDDEN_WITH_ERRORS_FILENAME];
                    
                    waitUntil(^(DoneCallback done) {
                        [client followUserForUsername:username
                                              success:callbacks.shouldNotExecuteSuccessCallback(done)
                                              failure:callbacks.shouldExecuteFailureCallbackWithMessage(FORBIDDEN_ERROR_MESSAGE, done)];
                    });
                });
                
                it(@"fails due to not found", ^{
                    [helper stubAuthenticatedRequestWithMethod:POST
                                                      urlRegex:followUserUrlRegex
                                           rawResponseFilename:NOT_FOUND_WITH_ERRORS_FILENAME];
                    
                    waitUntil(^(DoneCallback done) {
                        [client followUserForUsername:username
                                              success:callbacks.shouldNotExecuteSuccessCallback(done)
                                              failure:callbacks.shouldExecuteFailureCallbackWithMessage(NOT_FOUND_ERROR_MESSAGE, done)];
                    });
                });
            });
            
            describe(@"unfollow user", ^{
                __block NSRegularExpression *unfollowUserUrlRegex;
                
                beforeEach(^{
                    unfollowUserUrlRegex = [helper createUrlRegexForEndpoint:API_UNFOLLOW_USER
                                                              withParameters:pathParams];
                });
                
                it(@"is successful", ^{
                    [helper stubAuthenticatedRequestWithMethod:DELETE
                                                      urlRegex:unfollowUserUrlRegex
                                           rawResponseFilename:SUCCESSFUL_OK_WITH_NO_BODY_FILENAME];
                    
                    waitUntil(^(DoneCallback done) {
                        [client unfollowUserForUsername:username
                                                success:callbacks.shouldExecuteSuccessCallback(done)
                                                failure:callbacks.shouldNotExecuteFailureCallback(done)];
                    });
                });
                
                it(@"fails due to forbidden", ^{
                    [helper stubAuthenticatedRequestWithMethod:DELETE
                                                      urlRegex:unfollowUserUrlRegex
                                           rawResponseFilename:FORBIDDEN_WITH_ERRORS_FILENAME];
                    
                    waitUntil(^(DoneCallback done) {
                        [client unfollowUserForUsername:username
                                                success:callbacks.shouldNotExecuteSuccessCallback(done)
                                                failure:callbacks.shouldExecuteFailureCallbackWithMessage(FORBIDDEN_ERROR_MESSAGE, done)];
                    });
                });
                
                it(@"fails due to not found", ^{
                    [helper stubAuthenticatedRequestWithMethod:DELETE
                                                      urlRegex:unfollowUserUrlRegex
                                           rawResponseFilename:NOT_FOUND_WITH_ERRORS_FILENAME];
                    
                    waitUntil(^(DoneCallback done) {
                        [client unfollowUserForUsername:username
                                                success:callbacks.shouldNotExecuteSuccessCallback(done)
                                                failure:callbacks.shouldExecuteFailureCallbackWithMessage(NOT_FOUND_ERROR_MESSAGE, done)];
                    });
                });
            });
            
            describe(@"list followers", ^{
                __block NSRegularExpression *listFollowersUrlRegex;
                
                beforeEach(^{
                    listFollowersUrlRegex = [helper createUrlRegexForEndpoint:API_LIST_FOLLOWERS
                                                               withParameters:pathParams];
                });
                
                afterEach(^{
                    expect(httpClient.lastParameters.allKeys).to.haveCountOf(1);
                    expect(httpClient.lastParameters[@"page"]).to.equal(pageNumber);
                });
                
                it(@"is successful and has no users", ^{
                    [helper stubAuthenticatedRequestWithMethod:GET
                                                      urlRegex:listFollowersUrlRegex
                                           rawResponseFilename:SUCCESSFUL_OK_WITH_USERS_LIST_EMPTY];
                    
                    waitUntil(^(DoneCallback done) {
                        [client listFollowersPage:pageNumber
                              forUserWithUsername:username
                                          success:callbacks.shouldReceiveEmptyUserListInSuccessfulResponse(done)
                                          failure:callbacks.shouldNotExecuteFailureCallback(done)];
                    });
                });
                
                it(@"is successful and has one user", ^{
                    [helper stubAuthenticatedRequestWithMethod:GET
                                                      urlRegex:listFollowersUrlRegex
                                           rawResponseFilename:SUCCESSFUL_OK_WITH_USERS_LIST_ONE_USER];
                    
                    waitUntil(^(DoneCallback done) {
                        [client listFollowersPage:pageNumber
                              forUserWithUsername:username
                                          success:callbacks.shouldReceiveUserListWithOneUserInSuccessfulResponse(done)
                                          failure:callbacks.shouldNotExecuteFailureCallback(done)];
                    });
                });
                
                it(@"is successful and has multiple users", ^{
                    [helper stubAuthenticatedRequestWithMethod:GET
                                                      urlRegex:listFollowersUrlRegex
                                           rawResponseFilename:SUCCESSFUL_OK_WITH_USERS_LIST_MULTIPLE_USERS];
                    
                    waitUntil(^(DoneCallback done) {
                        [client listFollowersPage:pageNumber
                              forUserWithUsername:username
                                          success:callbacks.shouldReceiveUserListWithMultipleUsersInSuccessfulResponse(done)
                                          failure:callbacks.shouldNotExecuteFailureCallback(done)];
                    });
                });
                
                it(@"fails due to bad request", ^{
                    [helper stubAuthenticatedRequestWithMethod:GET
                                                      urlRegex:listFollowersUrlRegex
                                           rawResponseFilename:BAD_REQUEST_WITH_ERRORS_FILENAME];
                    
                    waitUntil(^(DoneCallback done) {
                        [client listFollowersPage:pageNumber
                              forUserWithUsername:username
                                          success:callbacks.shouldNotExecuteSuccessCallback(done)
                                          failure:callbacks.shouldExecuteFailureCallbackWithMessage(BAD_REQUEST_ERROR_MESSAGE, done)];
                    });
                });
            });
            
            describe(@"list followees", ^{
                __block NSRegularExpression *listFolloweesUrlRegex;
                
                beforeEach(^{
                    listFolloweesUrlRegex = [helper createUrlRegexForEndpoint:API_LIST_FOLLOWEES
                                                               withParameters:pathParams];
                });
                
                afterEach(^{
                    expect(httpClient.lastParameters.allKeys).to.haveCountOf(1);
                    expect(httpClient.lastParameters[@"page"]).to.equal(pageNumber);
                });
                
                it(@"is successful and has no users", ^{
                    [helper stubAuthenticatedRequestWithMethod:GET
                                                      urlRegex:listFolloweesUrlRegex
                                           rawResponseFilename:SUCCESSFUL_OK_WITH_USERS_LIST_EMPTY];
                    
                    waitUntil(^(DoneCallback done) {
                        [client listFolloweesPage:pageNumber
                              forUserWithUsername:username
                                          success:callbacks.shouldReceiveEmptyUserListInSuccessfulResponse(done)
                                          failure:callbacks.shouldNotExecuteFailureCallback(done)];
                    });
                });
                
                it(@"is successful and has one user", ^{
                    [helper stubAuthenticatedRequestWithMethod:GET
                                                      urlRegex:listFolloweesUrlRegex
                                           rawResponseFilename:SUCCESSFUL_OK_WITH_USERS_LIST_ONE_USER];
                    
                    waitUntil(^(DoneCallback done) {
                        [client listFolloweesPage:pageNumber
                              forUserWithUsername:username
                                          success:callbacks.shouldReceiveUserListWithOneUserInSuccessfulResponse(done)
                                          failure:callbacks.shouldNotExecuteFailureCallback(done)];
                    });
                });
                
                it(@"is successful and has multiple users", ^{
                    [helper stubAuthenticatedRequestWithMethod:GET
                                                      urlRegex:listFolloweesUrlRegex
                                           rawResponseFilename:SUCCESSFUL_OK_WITH_USERS_LIST_MULTIPLE_USERS];
                    
                    waitUntil(^(DoneCallback done) {
                        [client listFolloweesPage:pageNumber
                              forUserWithUsername:username
                                          success:callbacks.shouldReceiveUserListWithMultipleUsersInSuccessfulResponse(done)
                                          failure:callbacks.shouldNotExecuteFailureCallback(done)];
                    });
                });
                
                it(@"fails due to bad request", ^{
                    [helper stubAuthenticatedRequestWithMethod:GET
                                                      urlRegex:listFolloweesUrlRegex
                                           rawResponseFilename:BAD_REQUEST_WITH_ERRORS_FILENAME];
                    
                    waitUntil(^(DoneCallback done) {
                        [client listFolloweesPage:pageNumber
                              forUserWithUsername:username
                                          success:callbacks.shouldNotExecuteSuccessCallback(done)
                                          failure:callbacks.shouldExecuteFailureCallbackWithMessage(BAD_REQUEST_ERROR_MESSAGE, done)];
                    });
                });
            });
        });
        
        describe(@"list videos", ^{
            __block NSRegularExpression *listVideosUrlRegex;
            
            beforeEach(^{
                listVideosUrlRegex = [helper createUrlRegexForEndpoint:API_LIST_VIDEOS];
            });
            
            afterEach(^{
                expect(httpClient.lastParameters.allKeys).to.haveCountOf(1);
                expect(httpClient.lastParameters[@"page"]).to.equal(pageNumber);
            });
            
            it(@"is successful and has no videos", ^{
                [helper stubAuthenticatedRequestWithMethod:GET
                                                  urlRegex:listVideosUrlRegex
                                       rawResponseFilename:SUCCESSFUL_OK_WITH_VIDEOS_LIST_EMPTY];
                
                waitUntil(^(DoneCallback done) {
                    [client listVideosPage:pageNumber
                                   success:callbacks.shouldReceiveEmptyVideoListInSuccessfulResponse(done)
                                   failure:callbacks.shouldNotExecuteFailureCallback(done)];
                });
            });
            
            it(@"is successful and has one video", ^{
                [helper stubAuthenticatedRequestWithMethod:GET
                                                  urlRegex:listVideosUrlRegex
                                       rawResponseFilename:SUCCESSFUL_OK_WITH_VIDEOS_LIST_ONE_VIDEO];
                
                waitUntil(^(DoneCallback done) {
                    [client listVideosPage:pageNumber
                                   success:callbacks.shouldReceiveVideoListWithOneVideoInSuccessfulResponse(done)
                                   failure:callbacks.shouldNotExecuteFailureCallback(done)];
                });
            });
            
            it(@"is successful and has multiple videos", ^{
                [helper stubAuthenticatedRequestWithMethod:GET
                                                  urlRegex:listVideosUrlRegex
                                       rawResponseFilename:SUCCESSFUL_OK_WITH_VIDEOS_LIST_MULTIPLE_VIDEOS];
                
                waitUntil(^(DoneCallback done) {
                    [client listVideosPage:pageNumber
                                   success:callbacks.shouldReceiveVideoListWithMultipleVideosInSuccessfulResponse(done)
                                   failure:callbacks.shouldNotExecuteFailureCallback(done)];
                });
            });
            
            it(@"fails due to bad request", ^{
                [helper stubAuthenticatedRequestWithMethod:GET
                                                  urlRegex:listVideosUrlRegex
                                       rawResponseFilename:BAD_REQUEST_WITH_ERRORS_FILENAME];
                
                waitUntil(^(DoneCallback done) {
                    [client listVideosPage:pageNumber
                                   success:callbacks.shouldNotExecuteSuccessCallback(done)
                                   failure:callbacks.shouldExecuteFailureCallbackWithMessage(BAD_REQUEST_ERROR_MESSAGE, done)];
                });
            });
        });
       
        describe(@"add video", ^{
            __block NSRegularExpression *addVideoUrlRegex;
           
            __block NSURL *videoFileUrl;
            __block NSURL *thumbnailFileUrl;
            
            NSString *title = @"some video";
            NSString *reelName = @"some reel";
            
            beforeEach(^{
                addVideoUrlRegex = [helper createUrlRegexForEndpoint:API_ADD_VIDEO];
                
                NSBundle *bundle = [NSBundle bundleForClass:[self class]];

                videoFileUrl = [bundle URLForResource:@"small" withExtension:@"mp4"];
                thumbnailFileUrl = [bundle URLForResource:@"small" withExtension:@"png"];
            });

            afterEach(^{
                expect(httpClient.lastParameters.allKeys).to.haveCountOf(2);
                expect(httpClient.lastParameters[@"title"]).to.equal(title);
                expect(httpClient.lastParameters[@"reel"]).to.equal(reelName);
                expect(httpClient.lastFormDataBlock).toNot.beNil();

                id<AFMultipartFormData> formData = mockProtocol(@protocol(AFMultipartFormData));
                httpClient.lastFormDataBlock(formData);
                
                id videoVerification = [verify(formData) withMatcher:anything() forArgument:4];
                [videoVerification appendPartWithFileURL:videoFileUrl
                                                    name:@"video"
                                                fileName:@"some video.mp4"
                                                mimeType:@"video/mp4"
                                                   error:nil];
                
                id thumbnailVerification = [verify(formData) withMatcher:anything() forArgument:4];
                [thumbnailVerification appendPartWithFileURL:thumbnailFileUrl
                                                        name:@"thumbnail"
                                                    fileName:@"some video.png"
                                                    mimeType:@"image/png"
                                                       error:nil];
            });

            it(@"is successful", ^{
                [helper stubAuthenticatedRequestWithMethod:POST
                                                  urlRegex:addVideoUrlRegex
                                       rawResponseFilename:@"accepted-video"];
                
                waitUntil(^(DoneCallback done) {
                    [client addVideoFromFileURL:videoFileUrl
                           thumbnailFromFileURL:thumbnailFileUrl
                                      withTitle:title
                                 toReelWithName:reelName
                                        success:^(RTVideo *video) {
                                            expect(video).to.beVideo(@(9413), @"accepted video");
                                            done();
                                        }
                                        failure:callbacks.shouldNotExecuteFailureCallback(done)];
                });
            });
            
            it(@"fails due to bad request", ^{
                [helper stubAuthenticatedRequestWithMethod:POST
                                                  urlRegex:addVideoUrlRegex
                                       rawResponseFilename:BAD_REQUEST_WITH_ERRORS_FILENAME];
                
                waitUntil(^(DoneCallback done) {
                    [client addVideoFromFileURL:videoFileUrl
                           thumbnailFromFileURL:thumbnailFileUrl
                                      withTitle:title
                                 toReelWithName:reelName
                                        success:callbacks.shouldNotExecuteSuccessCallback(done)
                                        failure:callbacks.shouldExecuteFailureCallbackWithMessage(BAD_REQUEST_ERROR_MESSAGE, done)];
                });
            });
            
            it(@"fails due to forbidden", ^{
                [helper stubAuthenticatedRequestWithMethod:POST
                                                  urlRegex:addVideoUrlRegex
                                       rawResponseFilename:FORBIDDEN_WITH_ERRORS_FILENAME];
                
                waitUntil(^(DoneCallback done) {
                    [client addVideoFromFileURL:videoFileUrl
                           thumbnailFromFileURL:thumbnailFileUrl
                                      withTitle:title
                                 toReelWithName:reelName
                                        success:callbacks.shouldNotExecuteSuccessCallback(done)
                                        failure:callbacks.shouldExecuteFailureCallbackWithMessage(FORBIDDEN_ERROR_MESSAGE, done)];
                });
            });
            
            it(@"fails due to service unavailable", ^{
                [helper stubAuthenticatedRequestWithMethod:POST
                                                  urlRegex:addVideoUrlRegex
                                       rawResponseFilename:SERVICE_UNAVAILABLE_WITH_ERRORS_FILENAME];
                
                waitUntil(^(DoneCallback done) {
                    [client addVideoFromFileURL:videoFileUrl
                           thumbnailFromFileURL:thumbnailFileUrl
                                      withTitle:title
                                 toReelWithName:reelName
                                        success:callbacks.shouldNotExecuteSuccessCallback(done)
                                        failure:callbacks.shouldExecuteFailureCallbackWithMessage(SERVICE_UNAVAILABLE_ERROR_MESSAGE, done)];
                });
            });
        });
        
        context(@"video_id required in path", ^{
            __block NSMutableDictionary *pathParams;
            
            beforeEach(^{
                pathParams = [NSMutableDictionary dictionary];
                pathParams[@":video_id"] = [helper stringForUnsignedInteger:videoId];
            });
            
            afterEach(^{
                expect(httpClient.lastPath).to.contain(videoId);
            });

            describe(@"get video", ^{
                __block NSRegularExpression *getVideoUrlRegex;
                
                beforeEach(^{
                    getVideoUrlRegex = [helper createUrlRegexForEndpoint:API_GET_VIDEO
                                                          withParameters:pathParams];
                });
                
                it(@"is successful and ready for streaming", ^{
                    [helper stubAuthenticatedRequestWithMethod:GET
                                                      urlRegex:getVideoUrlRegex
                                           rawResponseFilename:@"single-video"];
                    
                    waitUntil(^(DoneCallback done) {
                        [client videoForVideoId:videoId
                                        success:^(RTVideo *video) {
                                            expect(video).to.beVideo(@(123), @"single video");
                                            done();
                                        }
                                        failure:callbacks.shouldNotExecuteFailureCallback(done)];
                    });
                });
                
                it(@"is successful but not ready for streaming", ^{
                    [helper stubAuthenticatedRequestWithMethod:GET
                                                      urlRegex:getVideoUrlRegex
                                           rawResponseFilename:@"accepted-video"];

                    waitUntil(^(DoneCallback done) {
                        [client videoForVideoId:videoId
                                        success:^(RTVideo *video) {
                                            expect(video).to.beVideo(@(9413), @"accepted video");
                                            done();
                                        }
                                        failure:callbacks.shouldNotExecuteFailureCallback(done)];
                    });
                });
                
                it(@"fails due to not found", ^{
                    [helper stubAuthenticatedRequestWithMethod:GET
                                                      urlRegex:getVideoUrlRegex
                                           rawResponseFilename:NOT_FOUND_WITH_ERRORS_FILENAME];
                    
                    waitUntil(^(DoneCallback done) {
                        [client videoForVideoId:videoId
                                        success:callbacks.shouldNotExecuteSuccessCallback(done)
                                        failure:callbacks.shouldExecuteFailureCallbackWithMessage(NOT_FOUND_ERROR_MESSAGE, done)];
                    });
                });
            });
            
            describe(@"delete video", ^{
                __block NSRegularExpression *deleteVideoUrlRegex;
                
                beforeEach(^{
                    deleteVideoUrlRegex = [helper createUrlRegexForEndpoint:API_DELETE_VIDEO
                                                             withParameters:pathParams];
                });
                
                it(@"is successful", ^{
                    [helper stubAuthenticatedRequestWithMethod:DELETE
                                                      urlRegex:deleteVideoUrlRegex
                                           rawResponseFilename:SUCCESSFUL_OK_WITH_NO_BODY_FILENAME];
                    
                    waitUntil(^(DoneCallback done) {
                        [client deleteVideoForVideoId:videoId
                                              success:callbacks.shouldExecuteSuccessCallback(done)
                                              failure:callbacks.shouldNotExecuteFailureCallback(done)];
                    });
                });
                
                it(@"fails due to not found", ^{
                    [helper stubAuthenticatedRequestWithMethod:DELETE
                                                      urlRegex:deleteVideoUrlRegex
                                           rawResponseFilename:NOT_FOUND_WITH_ERRORS_FILENAME];
                    
                    waitUntil(^(DoneCallback done) {
                        [client deleteVideoForVideoId:videoId
                                              success:callbacks.shouldNotExecuteSuccessCallback(done)
                                              failure:callbacks.shouldExecuteFailureCallbackWithMessage(NOT_FOUND_ERROR_MESSAGE, done)];
                    });
                });
            });
            
            describe(@"get thumbnail", ^{
                __block NSRegularExpression *getThumbnailUrlRegex;
                NSString *resolution = @"small";
                
                beforeEach(^{
                    getThumbnailUrlRegex = [helper createUrlRegexForEndpoint:API_GET_VIDEO_THUMBNAIL
                                                              withParameters:pathParams];
                });
                
                afterEach(^{
                    expect(httpClient.lastParameters.allKeys).to.haveCountOf(1);
                    expect(httpClient.lastParameters[@"resolution"]).to.equal(resolution);
                });
                
                it(@"is successful", ^{
                    [helper stubAuthenticatedRequestWithMethod:GET
                                                      urlRegex:getThumbnailUrlRegex
                                           rawResponseFilename:@"thumbnail"];
                    
                    waitUntil(^(DoneCallback done) {
                        [client thumbnailForVideoId:videoId
                                     withResolution:resolution
                                            success:^(RTThumbnail *thumbnail) {
                                                NSData *expectedData = [helper rawDataFromFile:@"small" ofType:@"png"];

                                                expect(thumbnail.data).to.equal(expectedData);
                                                done();
                                            }
                                            failure:callbacks.shouldNotExecuteFailureCallback(done)];
                    });
                });
            });
        });
    });
});

SpecEnd
