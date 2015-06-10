#import "RTTestCommon.h"

#import "RTRevokeClientInteractor.h"

#import "RTRevokeClientInteractorDelegate.h"
#import "RTRevokeClientDataManager.h"

#import "RTRevokeClientError.h"
#import "RTErrorFactory.h"

SpecBegin(RTRevokeClientInteractor)

describe(@"revoke client interactor", ^{

    __block RTRevokeClientInteractor *interactor;

    __block id<RTRevokeClientInteractorDelegate> delegate;
    __block RTRevokeClientDataManager *dataManager;
    
    __block MKTArgumentCaptor *successCaptor;
    __block MKTArgumentCaptor *failureCaptor;

    beforeEach(^{
        delegate = mockProtocol(@protocol(RTRevokeClientInteractorDelegate));
        dataManager = mock([RTRevokeClientDataManager class]);
        
        interactor = [[RTRevokeClientInteractor alloc] initWithDelegate:delegate
                                                            dataManager:dataManager];
        
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
            
            it(@"should notify delegate of success", ^{
                NoArgsCallback callback = [successCaptor value];
                callback();
                [verify(delegate) clientRevocationSucceededForClientWithClientId:clientId];
            });
            
            it(@"should notify delegate of failure", ^{
                ArrayCallback callback = [failureCaptor value];
                
                NSError *error = [RTErrorFactory revokeClientErrorWithCode:RTRevokeClientErrorUnknownClient];
                callback(@[error]);
                
                MKTArgumentCaptor *captor = [[MKTArgumentCaptor alloc] init];
                [verify(delegate) clientRevocationFailedWithErrors:[captor capture]];
                
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
                [verify(delegate) clientRevocationFailedWithErrors:[errorCaptor capture]];
                
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
