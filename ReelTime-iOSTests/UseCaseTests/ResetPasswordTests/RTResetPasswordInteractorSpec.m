#import "RTTestCommon.h"

#import "RTResetPasswordInteractor.h"
#import "RTResetPasswordInteractorDelegate.h"

#import "RTResetPasswordDataManager.h"
#import "RTResetPasswordError.h"

#import "RTCurrentUserService.h"
#import "RTClientCredentialsService.h"

SpecBegin(RTResetPasswordInteractor)

describe(@"reset password interactor", ^{
    
    __block RTResetPasswordInteractor *interactor;
    
    __block id<RTResetPasswordInteractorDelegate> delegate;
    __block RTResetPasswordDataManager *dataManager;

    __block RTCurrentUserService *currentUserService;
    __block RTClientCredentialsService *clientCredentialsService;

    __block MKTArgumentCaptor *callbackCaptor;
    __block MKTArgumentCaptor *errorCaptor;
    
    beforeEach(^{
        clientCredentialsService = mock([RTClientCredentialsService class]);
        currentUserService = mock([RTCurrentUserService class]);
        
        dataManager = mock([RTResetPasswordDataManager class]);
        delegate = mockProtocol(@protocol(RTResetPasswordInteractorDelegate));
        
        interactor = [[RTResetPasswordInteractor alloc] initWithDelegate:delegate
                                                             dataManager:dataManager
                                                      currentUserService:currentUserService
                                                clientCredentialsService:clientCredentialsService];
        
        callbackCaptor = [[MKTArgumentCaptor alloc] init];
        errorCaptor = [[MKTArgumentCaptor alloc] init];
    });
    
    describe(@"send reset password email", ^{
        it(@"missing username", ^{
            [interactor sendResetPasswordEmailForUsername:BLANK];
            [verify(delegate) resetPasswordEmailFailedWithErrors:[errorCaptor capture]];
            
            NSArray *errors = [errorCaptor value];
            expect(errors).to.haveACountOf(1);
            expect(errors[0]).to.beError(RTResetPasswordErrorDomain, RTResetPasswordErrorMissingUsername);
        });
        
        it(@"should notify delegate when email is sent", ^{
            [interactor sendResetPasswordEmailForUsername:username];
            [verify(dataManager) submitRequestForResetPasswordEmailForUsername:username
                                                                  withCallback:[callbackCaptor capture]];
            
            [verifyCount(delegate, never()) resetPasswordEmailSent];
            
            void (^callback)() = [callbackCaptor value];
            callback();
            
            [verify(delegate) resetPasswordEmailSent];
        });
    });
});

SpecEnd