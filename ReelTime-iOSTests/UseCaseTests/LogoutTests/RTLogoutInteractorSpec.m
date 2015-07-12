#import "RTTestCommon.h"

#import "RTLogoutInteractor.h"

#import "RTLogoutInteractorDelegate.h"
#import "RTLogoutDataManager.h"

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
    });
});

SpecEnd