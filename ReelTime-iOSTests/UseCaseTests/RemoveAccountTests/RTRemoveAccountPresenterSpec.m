#import "RTTestCommon.h"

#import "RTRemoveAccountPresenter.h"
#import "RTRemoveAccountView.h"

#import "RTRemoveAccountInteractor.h"
#import "RTRemoveAccountWireframe.h"

#import "RTErrorFactory.h"

SpecBegin(RTRemoveAccountPresenter)

describe(@"remove account presenter", ^{
    
    __block RTRemoveAccountPresenter *presenter;
    __block id<RTRemoveAccountView> view;

    __block RTRemoveAccountInteractor *interactor;
    __block RTRemoveAccountWireframe *wireframe;
    
    beforeEach(^{
        wireframe = mock([RTRemoveAccountWireframe class]);
        interactor = mock([RTRemoveAccountInteractor class]);
        
        view = mockProtocol(@protocol(RTRemoveAccountView));
        presenter = [[RTRemoveAccountPresenter alloc] initWithView:view
                                                        interactor:interactor
                                                         wireframe:wireframe];
    });
    
    describe(@"requesting account removal", ^{
        it(@"should pass on to interactor", ^{
            [presenter requestedAccountRemoval];
            [verify(interactor) removeAccount];
        });
    });
    
    describe(@"account removal succeeded", ^{
        it(@"should present the post removal interface", ^{
            [presenter removeAccountSucceeded];
            [verify(wireframe) presentPostRemoveAccountInterface];
        });
    });
    
    describe(@"account removal failure messages", ^{
        it(@"unauthorized", ^{
            NSError *error = [RTErrorFactory removeAccountErrorWithCode:RTRemoveAccountErrorUnauthorized];
            
            [presenter removeAccountFailedWithError:error];
            [verify(view) showErrorMessage:@"You are not authorized to remove this account!"];
        });
        
        it(@"unknown error", ^{
            NSError *error = [RTErrorFactory removeAccountErrorWithCode:RTRemoveAccountErrorUnknownError];
            
            [presenter removeAccountFailedWithError:error];
            [verify(view) showErrorMessage:@"Unknown error occurred while removing account. Please try again."];
        });
    });
});

SpecEnd
