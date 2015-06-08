#import "RTTestCommon.h"

#import "RTRevokeClientPresenter.h"
#import "RTRevokeClientView.h"
#import "RTRevokeClientInteractor.h"

SpecBegin(RTRevokeClientPresenter)

describe(@"revoke client presenter", ^{
    
    __block RTRevokeClientPresenter *presenter;

    __block id<RTRevokeClientView> view;
    __block RTRevokeClientInteractor *interactor;
    
    beforeEach(^{
        view = mockProtocol(@protocol(RTRevokeClientView));
        interactor = mock([RTRevokeClientInteractor class]);
        
        presenter = [[RTRevokeClientPresenter alloc] initWithView:view
                                                       interactor:interactor];
    });
    
    describe(@"requested client revocation", ^{
        it(@"should pass client id to interactor", ^{
            [presenter requestedRevocationForClientWithClientId:clientId];
            [verify(interactor) revokeClientWithClientId:clientId];
        });
    });
});

SpecEnd
