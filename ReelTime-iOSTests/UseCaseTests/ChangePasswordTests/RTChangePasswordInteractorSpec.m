#import "RTTestCommon.h"

#import "RTChangePasswordInteractor.h"
#import "RTChangePasswordInteractorDelegate.h"
#import "RTChangePasswordDataManager.h"

SpecBegin(RTChangePasswordInteractor)

describe(@"change password interactor", ^{
    
    __block RTChangePasswordInteractor *interactor;

    __block id<RTChangePasswordInteractorDelegate> delegate;
    __block RTChangePasswordDataManager *dataManager;
    
    __block MKTArgumentCaptor *changedCaptor;
    __block MKTArgumentCaptor *notChangedCaptor;
    
    beforeEach(^{
        dataManager = mock([RTChangePasswordDataManager class]);
        delegate = mockProtocol(@protocol(RTChangePasswordInteractorDelegate));
        
        interactor = [[RTChangePasswordInteractor alloc] initWithDelegate:delegate
                                                              dataManager:dataManager];
        
        changedCaptor = [[MKTArgumentCaptor alloc] init];
        notChangedCaptor = [[MKTArgumentCaptor alloc] init];
    });
    
    context(@"valid parameters", ^{
        beforeEach(^{
            [interactor changePassword:password confirmationPassword:password];
            [verify(dataManager) changePassword:password
                                        changed:[changedCaptor capture]
                                     notChanged:[notChangedCaptor capture]];
        });
        
        it(@"should notify delegate of success", ^{
            NoArgsCallback callback = [changedCaptor value];
            callback();
            [verify(delegate) changePasswordSucceeded];
        });
    });
    
    context(@"invalid parameters", ^{
        // TODO: Refactor expectErrors from validator spec for reuse
    });
});

SpecEnd
