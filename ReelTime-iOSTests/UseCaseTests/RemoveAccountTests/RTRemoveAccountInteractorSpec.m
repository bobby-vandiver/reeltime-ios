#import "RTTestCommon.h"

#import "RTRemoveAccountInteractor.h"

#import "RTRemoveAccountInteractorDelegate.h"
#import "RTRemoveAccountDataManager.h"

#import "RTRemoveAccountError.h"
#import "RTErrorFactory.h"

SpecBegin(RTRemoveAccountInteractor)

describe(@"remove account interactor", ^{
    
    __block RTRemoveAccountInteractor *interactor;
    
    __block id<RTRemoveAccountInteractorDelegate> delegate;
    __block RTRemoveAccountDataManager *dataManager;
    
    __block MKTArgumentCaptor *successCaptor;
    __block MKTArgumentCaptor *failureCaptor;

    beforeEach(^{
        delegate = mockProtocol(@protocol(RTRemoveAccountInteractorDelegate));
        dataManager = mock([RTRemoveAccountDataManager class]);
        
        interactor = [[RTRemoveAccountInteractor alloc] initWithDelegate:delegate
                                                             dataManager:dataManager];
        
        successCaptor = [[MKTArgumentCaptor alloc] init];
        failureCaptor = [[MKTArgumentCaptor alloc] init];
    });
    
    describe(@"removing account", ^{
        beforeEach(^{
            [interactor removeAccount];
            [verify(dataManager) removeAccount:[successCaptor capture]
                                       failure:[failureCaptor capture]];
        });
        
        it(@"should notify delegate of success", ^{
            NoArgsCallback successHandler = [successCaptor value];
            successHandler();
            [verify(delegate) removeAccountSucceeded];
        });
        
        it(@"should notify delegate of failure", ^{
            ErrorCallback failureHandler = [failureCaptor value];
            
            NSError *error = [RTErrorFactory removeAccountErrorWithCode:RTRemoveAccountErrorUnauthorized];
            failureHandler(error);
            
            [verify(delegate) removeAccountFailedWithError:error];
        });
    });
});

SpecEnd
