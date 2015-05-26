#import "RTTestCommon.h"

#import "RTChangeDisplayNameInteractor.h"
#import "RTChangeDisplayNameInteractorDelegate.h"
#import "RTChangeDisplayNameDataManager.h"

#import "RTChangeDisplayNameError.h"
#import "RTErrorFactory.h"

SpecBegin(RTChangeDisplayNameInteractor)

describe(@"change display name interactor", ^{
    
    __block RTChangeDisplayNameInteractor *interactor;
    
    __block id<RTChangeDisplayNameInteractorDelegate> delegate;
    __block RTChangeDisplayNameDataManager *dataManager;
    
    __block MKTArgumentCaptor *changedCaptor;
    __block MKTArgumentCaptor *notChangedCaptor;
    
    beforeEach(^{
        dataManager = mock([RTChangeDisplayNameDataManager class]);
        delegate = mockProtocol(@protocol(RTChangeDisplayNameInteractorDelegate));
        
        interactor = [[RTChangeDisplayNameInteractor alloc] initWithDelegate:delegate
                                                                 dataManager:dataManager];
        
        changedCaptor = [[MKTArgumentCaptor alloc] init];
        notChangedCaptor = [[MKTArgumentCaptor alloc] init];
    });
    
    describe(@"change display name", ^{
        context(@"valid parameters", ^{
            beforeEach(^{
                [interactor changeDisplayName:displayName];
                [verify(dataManager) changeDisplayName:displayName
                                               changed:[changedCaptor capture]
                                            notChanged:[notChangedCaptor capture]];
            });
            
            it(@"should notify delegate of success", ^{
                NoArgsCallback callback = [changedCaptor value];
                callback();
                [verify(delegate) changeDisplayNameSucceeded];
            });
            
            it(@"should notify delegate of failure", ^{
                ArrayCallback callback = [notChangedCaptor value];
                
                NSError *error = [RTErrorFactory changeDisplayNameWithCode:RTChangeDisplayNameErrorInvalidDisplayName];
                callback(@[error]);
                
                MKTArgumentCaptor *captor = [[MKTArgumentCaptor alloc] init];
                [verify(delegate) changeDisplayNameFailedWithErrors:[captor capture]];
                
                NSArray *captured = [captor value];
                expect(captured).to.haveACountOf(1);
                expect(captured).to.contain(error);
            });
        });
        
        context(@"missing or invalid parameters", ^{
            __block RTValidationTestHelper *helper;
            
            ValidationCallback validationCallback = ^BOOL (NSDictionary *parameters, NSArray *__autoreleasing *errors) {
                NSString *displayNameParam = parameters[DISPLAY_NAME_KEY];
                
                [interactor changeDisplayName:getParameterOrDefault(displayNameParam, displayName)];
                
                MKTArgumentCaptor *errorCaptor = [[MKTArgumentCaptor alloc] init];
                [verify(delegate) changeDisplayNameFailedWithErrors:[errorCaptor capture]];
                
                [verify(delegate) reset];
                
                NSArray *capturedErrors = [errorCaptor value];
                *errors = capturedErrors;
                
                return NO;
            };
            
            ErrorFactoryCallback errorFactoryCallback = ^NSError * (NSInteger errorCode) {
                return [RTErrorFactory changeDisplayNameWithCode:errorCode];
            };
            
            beforeEach(^{
                helper = [[RTValidationTestHelper alloc] initWithValidationCallback:validationCallback
                                                               errorFactoryCallback:errorFactoryCallback];
            });
            
            it(@"blank display name", ^{
                [helper expectErrorCodes:@[@(RTChangeDisplayNameErrorMissingDisplayName)] forParameters:@{DISPLAY_NAME_KEY: BLANK}];
                [helper expectErrorCodes:@[@(RTChangeDisplayNameErrorMissingDisplayName)] forParameters:@{DISPLAY_NAME_KEY: null()}];
            });
            
            it(@"too short", ^{
                [helper expectErrorCodes:@[@(RTChangeDisplayNameErrorInvalidDisplayName)] forParameters:@{DISPLAY_NAME_KEY: @"a"}];
            });
            
            it(@"too long", ^{
                [helper expectErrorCodes:@[@(RTChangeDisplayNameErrorInvalidDisplayName)] forParameters:@{DISPLAY_NAME_KEY: @"123456789012345678901"}];
            });
            
            it(@"cannot contain leading or trailing space", ^{
                [helper expectErrorCodes:@[@(RTChangeDisplayNameErrorInvalidDisplayName)] forParameters:@{DISPLAY_NAME_KEY: @" "}];
                [helper expectErrorCodes:@[@(RTChangeDisplayNameErrorInvalidDisplayName)] forParameters:@{DISPLAY_NAME_KEY: @" a"}];
                [helper expectErrorCodes:@[@(RTChangeDisplayNameErrorInvalidDisplayName)] forParameters:@{DISPLAY_NAME_KEY: @"a "}];
            });
            
            it(@"cannot contain non-word characters", ^{
                [helper expectErrorCodes:@[@(RTChangeDisplayNameErrorInvalidDisplayName)] forParameters:@{DISPLAY_NAME_KEY: @"!a"}];
                [helper expectErrorCodes:@[@(RTChangeDisplayNameErrorInvalidDisplayName)] forParameters:@{DISPLAY_NAME_KEY: @"!ab"}];
                [helper expectErrorCodes:@[@(RTChangeDisplayNameErrorInvalidDisplayName)] forParameters:@{DISPLAY_NAME_KEY: @"1234567890123456789!"}];
            });
        });
    });
});

SpecEnd