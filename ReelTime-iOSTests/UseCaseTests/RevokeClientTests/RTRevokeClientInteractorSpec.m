#import "RTTestCommon.h"

#import "RTRevokeClientInteractor.h"

#import "RTRevokeClientInteractorDelegate.h"
#import "RTRevokeClientDataManager.h"

#import "RTCurrentUserService.h"
#import "RTClientCredentials.h"

#import "RTRevokeClientError.h"
#import "RTErrorFactory.h"

SpecBegin(RTRevokeClientInteractor)

describe(@"revoke client interactor", ^{

    __block RTRevokeClientInteractor *interactor;
    __block id<RTRevokeClientInteractorDelegate> delegate;
    
    __block RTRevokeClientDataManager *dataManager;
    __block RTCurrentUserService *currentUserService;
 
    __block MKTArgumentCaptor *successCaptor;
    __block MKTArgumentCaptor *failureCaptor;

    beforeEach(^{
        delegate = mockProtocol(@protocol(RTRevokeClientInteractorDelegate));

        dataManager = mock([RTRevokeClientDataManager class]);
        currentUserService = mock([RTCurrentUserService class]);
        
        interactor = [[RTRevokeClientInteractor alloc] initWithDelegate:delegate
                                                            dataManager:dataManager
                                                     currentUserService:currentUserService];
        
        successCaptor = [[MKTArgumentCaptor alloc] init];
        failureCaptor = [[MKTArgumentCaptor alloc] init];
    });
    
    describe(@"revoking client", ^{
        context(@"valid parameters", ^{
            beforeEach(^{
                [interactor revokeClientWithClientId:clientId];
                [verify(dataManager) revokeClientWithClientId:clientId
                                            revocationSuccees:[successCaptor capture]
                                                      failure:[failureCaptor capture]];
            });
            
            it(@"should notify delegate of success -- revoked client is the current client", ^{
                RTClientCredentials *clientCredentials = [[RTClientCredentials alloc] initWithClientId:clientId
                                                                                          clientSecret:anything()];
                [given([currentUserService clientCredentialsForCurrentUser]) willReturn:clientCredentials];
                
                NoArgsCallback callback = [successCaptor value];
                callback();
                [verify(delegate) clientRevocationSucceededForClientWithClientId:clientId currentClient:YES];
            });
            
            it(@"should notify delegate of success -- revoked client is not the current client", ^{
                NSString *differentClientId = [clientId stringByAppendingString:@"a"];
                RTClientCredentials *clientCredentials = [[RTClientCredentials alloc] initWithClientId:differentClientId
                                                                                          clientSecret:anything()];
                [given([currentUserService clientCredentialsForCurrentUser]) willReturn:clientCredentials];
                
                NoArgsCallback callback = [successCaptor value];
                callback();
                [verify(delegate) clientRevocationSucceededForClientWithClientId:clientId currentClient:NO];
            });
            
            it(@"should notify delegate of failure", ^{
                ArrayCallback callback = [failureCaptor value];
                
                NSError *error = [RTErrorFactory revokeClientErrorWithCode:RTRevokeClientErrorUnknownClient];
                callback(@[error]);
                
                MKTArgumentCaptor *captor = [[MKTArgumentCaptor alloc] init];
                [verify(delegate) clientRevocationFailedForClientWithClientId:clientId errors:[captor capture]];

                NSArray *captured = [captor value];
                expect(captured).to.haveACountOf(1);
                expect(captured).to.contain(error);
            });
        });
        
        context(@"missing or invalid parameters", ^{
            __block RTValidationTestHelper *helper;
            
            ValidationCallback validationCallback = ^BOOL (NSDictionary *parameters, NSArray *__autoreleasing *errors) {
                NSString *clientIdParam = parameters[CLIENT_ID_KEY];
                
                [interactor revokeClientWithClientId:getParameterOrDefault(clientIdParam, clientId)];
                
                MKTArgumentCaptor *errorCaptor = [[MKTArgumentCaptor alloc] init];
                [verify(delegate) clientRevocationFailedForClientWithClientId:anything() errors:[errorCaptor capture]];
                
                [verify(delegate) reset];
                
                NSArray *capturedErrors = [errorCaptor value];
                *errors = capturedErrors;
                
                return NO;
            };
            
            ErrorFactoryCallback errorFactoryCallback = ^NSError * (NSInteger errorCode) {
                return [RTErrorFactory revokeClientErrorWithCode:errorCode];
            };
            
            beforeEach(^{
                helper = [[RTValidationTestHelper alloc] initWithValidationCallback:validationCallback
                                                               errorFactoryCallback:errorFactoryCallback];
            });
            
            it(@"blank client id", ^{
                [helper expectErrorCodes:@[@(RTRevokeClientErrorMissingClientId)] forParameters:@{CLIENT_ID_KEY: BLANK}];
                [helper expectErrorCodes:@[@(RTRevokeClientErrorMissingClientId)] forParameters:@{CLIENT_ID_KEY: null()}];
            });
        });
    });
});

SpecEnd
