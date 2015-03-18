#import "RTTestCommon.h"

#import "RTPagedListPresenter.h"
#import "RTPagedListPresenterDelegate.h"
#import "RTPagedListInteractor.h"

SpecBegin(RTPagedListPresenter)

describe(@"paged list presenter", ^{
    
    __block RTPagedListPresenter *presenter;
    
    __block id<RTPagedListPresenterDelegate> delegate;
    __block RTPagedListInteractor *interactor;
    
    __block BOOL callbackExecuted;
    
    RefreshCompletedCallback refreshCallback = ^{
        callbackExecuted = YES;
    };

    beforeEach(^{
        callbackExecuted = NO;

        delegate = mockProtocol(@protocol(RTPagedListPresenterDelegate));
        interactor = mock([RTPagedListInteractor class]);
        presenter = [[RTPagedListPresenter alloc] initWithDelegate:delegate
                                                        interactor:interactor];
    });
    
    describe(@"page requested", ^{
        it(@"should allow next request once previous one has finished with results", ^{
            [presenter requestedNextPage];
            [verify(interactor) listItemsForPage:1];

            NSObject *obj = [NSObject new];
            [presenter retrievedItems:@[obj]];
            
            [presenter requestedNextPage];
            [verify(interactor) listItemsForPage:2];
        });
        
        it(@"should not allow multiple requests until the previous one has finisehd", ^{
            [presenter requestedNextPage];
            [verify(interactor) listItemsForPage:1];
            
            [presenter requestedNextPage];
            [verifyCount(interactor, never()) listItemsForPage:2];
        });
        
        it(@"should not request any more items after receiving an empty list of results", ^{
            [presenter retrievedItems:@[]];
            
            [presenter requestedNextPage];
            [[verifyCount(interactor, never()) withMatcher:anything() forArgument:0] listItemsForPage:0];
        });
    });
    
    describe(@"refresh", ^{
        it(@"should reset page counter and request that the first page is retrieved", ^{
            [presenter requestedNextPage];
            [verify(interactor) listItemsForPage:1];

            NSObject *obj = [NSObject new];
            [presenter retrievedItems:@[obj]];
            
            [presenter requestedNextPage];
            [verify(interactor) listItemsForPage:2];
            
            [verify(interactor) reset];

            [presenter requestedRefreshWithCallback:refreshCallback];
            [verify(interactor) listItemsForPage:1];
        });
        
        it(@"should notify view that currently displayed messages should be removed", ^{
            [presenter requestedRefreshWithCallback:refreshCallback];
            [verify(delegate) clearPresentedItems];
        });

        it(@"should execute callback when refresh has completed", ^{
            [presenter requestedRefreshWithCallback:refreshCallback];
            expect(callbackExecuted).to.beFalsy();
            
            [presenter retrievedItems:@[]];
            expect(callbackExecuted).to.beTruthy();
        });
        
        it(@"should not execute callback if refresh was not previously requested", ^{
            [presenter retrievedItems:@[]];
            expect(callbackExecuted).to.beFalsy();
        });
    });
    
    describe(@"present retrieved items", ^{
        it(@"no items to present", ^{
            [presenter retrievedItems:@[]];
            [verifyCount(delegate, never()) presentItem:anything()];
        });
        
        it(@"one item to present", ^{
            id first = [NSObject new];

            [presenter retrievedItems:@[first]];
            [verify(delegate) presentItem:first];
        });
        
        it(@"multiple items to present", ^{
            id first = [NSObject new];
            id second = [NSObject new];
            id third = [NSObject new];
            
            [presenter retrievedItems:@[first, second, third]];
            
            [verify(delegate) presentItem:first];
            [verify(delegate) presentItem:second];
            [verify(delegate) presentItem:third];
        });
        
        it(@"present each item once", ^{
            id item = [NSObject new];
            NSArray *items = @[item];
            
            [presenter retrievedItems:items];
            [verify(delegate) presentItem:item];
            
            [verify(delegate) reset];
            
            [presenter retrievedItems:items];
            [verifyCount(delegate, never()) presentItem:anything()];
        });
        
        it(@"present item after refresh", ^{
            id item = [NSObject new];
            NSArray *items = @[item];
            
            [presenter retrievedItems:items];
            [verify(delegate) presentItem:item];
            
            [verify(delegate) reset];
            [presenter requestedRefreshWithCallback:refreshCallback];
            
            [presenter retrievedItems:items];
            [verify(delegate) presentItem:item];
        });
    });
});

SpecEnd
