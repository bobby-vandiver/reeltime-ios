#import "RTTestCommon.h"

#import "RTPagedListInteractor.h"
#import "RTPagedListInteractorDelegate.h"
#import "RTPagedListDataManager.h"
#import "RTPagedListError.h"

SpecBegin(RTPagedListInteractor)

describe(@"paged list interactor", ^{
    
    __block RTPagedListInteractor *interactor;
    
    __block id<RTPagedListInteractorDelegate> delegate;
    __block RTPagedListDataManager *dataManager;
    
    beforeEach(^{
        delegate = mockProtocol(@protocol(RTPagedListInteractorDelegate));
        dataManager = mock([RTPagedListDataManager class]);
        
        interactor = [[RTPagedListInteractor alloc] initWithDelegate:delegate
                                                         dataManager:dataManager];
    });
    
    describe(@"successful page retrieval", ^{
        const NSUInteger page = 23;
        
        it(@"should pass list page to delegate", ^{
            [interactor listPage:page];
            
            MKTArgumentCaptor *callbackCaptor = [[MKTArgumentCaptor alloc] init];
            
            [verify(dataManager) retrievePage:page
                                     callback:[callbackCaptor capture]];
            
            NSObject *listPage = [[NSObject alloc] init];
            [verifyCount(delegate, never()) retrievedListPage:listPage];
            
            void (^callback)(id) = [callbackCaptor value];
            callback(listPage);
            
            [verify(delegate) retrievedListPage:listPage];
        });
    });
    
    describe(@"newsfeed page retrieval failure", ^{
        it(@"should not allow non-negative numbers", ^{
            const NSUInteger invalidPage = 0;
            [interactor listPage:invalidPage];
            
            MKTArgumentCaptor *errorCaptor = [[MKTArgumentCaptor alloc] init];
            [verify(delegate) failedToRetrieveListPageWithError:[errorCaptor capture]];
            
            NSError *error = [errorCaptor value];
            expect(error).to.beError(RTPagedListErrorDomain, RTPagedListErrorInvalidPageNumber);
        });
    });
});

SpecEnd