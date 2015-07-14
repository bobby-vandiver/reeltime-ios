#import "RTTestCommon.h"

#import "RTLogoutInteractor.h"

#import "RTLogoutInteractorDelegate.h"
#import "RTLogoutDataManager.h"

#import "RTLogoutError.h"
#import "RTErrorFactory.h"

SpecBegin(RTLogoutInteractor)

describe(@"logout interactor", ^{
    
    __block RTLogoutInteractor *interactor;

    __block id<RTLogoutInteractorDelegate> delegate;
    __block RTLogoutDataManager *dataManager;

    beforeEach(^{
        delegate = mockProtocol(@protocol(RTLogoutInteractorDelegate));
        dataManager = mock([RTLogoutDataManager class]);
        
        interactor = [[RTLogoutInteractor alloc] initWithDelegate:delegate
                                                      dataManager:dataManager];
    });
    
    describe(@"logout", ^{
        __block MKTArgumentCaptor *tokenRevocationSuccess;
        __block MKTArgumentCaptor *tokenRevocationFailure;
        
        __block MKTArgumentCaptor *removeLocalCredentialsSuccess;
        __block MKTArgumentCaptor *removeLocalCredentialsFailure;
        

        beforeEach(^{
            tokenRevocationSuccess = [[MKTArgumentCaptor alloc] init];
            tokenRevocationFailure = [[MKTArgumentCaptor alloc] init];
            
            removeLocalCredentialsSuccess = [[MKTArgumentCaptor alloc] init];
            removeLocalCredentialsFailure = [[MKTArgumentCaptor alloc] init];
        });
        
        context(@"token revocation requested", ^{
            beforeEach(^{
                [interactor logout];
                [verify(dataManager) revokeCurrentTokenWithSuccess:[tokenRevocationSuccess capture]
                                                           failure:[tokenRevocationFailure capture]];
            });
            
            it(@"token revocation failure", ^{
                ErrorCallback failureCallback = [tokenRevocationFailure value];

                NSError *error = [RTErrorFactory logoutErrorWithCode:RTLogoutErrorUnknownRevocationError];
                failureCallback(error);
                
                [verify(delegate) logoutFailed];
            });
            
            context(@"token revocation succeeded and local credentials removal requested", ^{
                beforeEach(^{
                    NoArgsCallback successCallback = [tokenRevocationSuccess value];
                    successCallback();
                    [verify(dataManager) removeLocalCredentialsWithSuccess:[removeLocalCredentialsSuccess capture]
                                                                   failure:[removeLocalCredentialsFailure capture]];
                });
                
                it(@"failed to remove local credentials", ^{
                    ErrorCallback failureCallback = [removeLocalCredentialsFailure value];
                    
                    NSError *error = [RTErrorFactory logoutErrorWithCode:RTLogoutErrorFailedToRemoveStoredToken];
                    failureCallback(error);
                    
                    [verify(delegate) logoutFailed];
                });
                
                it(@"should notify delegate of successful logout", ^{
                    NoArgsCallback successCallback = [removeLocalCredentialsSuccess value];
                    successCallback();
                    [verify(delegate) logoutSucceeded];
                });
            });
        });
    });
});

SpecEnd