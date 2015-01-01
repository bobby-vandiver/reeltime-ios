#import "RTTestCommon.h"

#import "RTLoginPresenter.h"
#import "RTLoginView.h"
#import "RTLoginInteractor.h"

SpecBegin(RTLoginPresenter)

describe(@"login presenter", ^{
    
    __block RTLoginPresenter *presenter;
    
    __block RTLoginInteractor *interactor;
    __block id<RTLoginView> view;
    
    beforeEach(^{
        view = mockProtocol(@protocol(RTLoginView));
        interactor = mock([RTLoginInteractor class]);
        
        presenter = [[RTLoginPresenter alloc] initWithView:view
                                                interactor:interactor];
    });
    
    describe(@"login requested", ^{
    });
    
});

SpecEnd
