#import "RTTestCommon.h"

#import "RTPagedListPresenter.h"
#import "RTPagedListPresenterDelegate.h"
#import "RTPagedListInteractor.h"

SpecBegin(RTPagedListPresenter)

describe(@"paged list presenter", ^{
    
    __block RTPagedListPresenter *presenter;
    
    __block id<RTPagedListPresenterDelegate> delegate;
    __block RTPagedListInteractor *interactor;
    
    beforeEach(^{
        delegate = mockProtocol(@protocol(RTPagedListPresenterDelegate));
        interactor = mock([RTPagedListInteractor class]);
        presenter = [[RTPagedListPresenter alloc] initWithDelegate:delegate
                                                        interactor:interactor];
    });
    
    describe(@"page requested", ^{
        it(@"should always get the next requested page", ^{
            [presenter requestedNextPage];
            [verify(interactor) listItemsForPage:1];
            
            [presenter requestedNextPage];
            [verify(interactor) listItemsForPage:2];
            
            [presenter requestedNextPage];
            [verify(interactor) listItemsForPage:3];
        });
    });
    
    describe(@"reset", ^{
        it(@"should reset page counter so the first page is retrieved next", ^{
            [presenter requestedNextPage];
            [verify(interactor) listItemsForPage:1];
            
            [presenter requestedNextPage];
            [verify(interactor) listItemsForPage:2];
            
            [presenter requestedReset];
            [verify(interactor) reset];
            
            [presenter requestedNextPage];
            [verify(interactor) listItemsForPage:1];
        });
        
        it(@"should notify view that currently displayed messages should be removed", ^{
            [presenter requestedReset];
            [verify(delegate) clearPresentedItems];
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
        
        it(@"present item after reset", ^{
            id item = [NSObject new];
            NSArray *items = @[item];
            
            [presenter retrievedItems:items];
            [verify(delegate) presentItem:item];
            
            [verify(delegate) reset];
            [presenter requestedReset];
            
            [presenter retrievedItems:items];
            [verify(delegate) presentItem:item];
        });
    });
});

SpecEnd
