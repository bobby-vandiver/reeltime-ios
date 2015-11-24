#import "RTTestCommon.h"

#import "RTRemoveAccountViewController.h"
#import "RTRemoveAccountPresenter.h"

SpecBegin(RTRemoveAccountViewController)

describe(@"remove account view controller", ^{
    
    __block RTRemoveAccountViewController *viewController;
    __block RTRemoveAccountPresenter *presenter;

    beforeEach(^{
        presenter = mock([RTRemoveAccountPresenter class]);
        viewController = [RTRemoveAccountViewController viewControllerWithPresenter:presenter];
    });
    
    describe(@"when remove button is pressed", ^{
        it(@"should request account removal", ^{
            [viewController pressedRemoveButton];
            [verify(presenter) requestedAccountRemoval];
        });
    });
});

SpecEnd
