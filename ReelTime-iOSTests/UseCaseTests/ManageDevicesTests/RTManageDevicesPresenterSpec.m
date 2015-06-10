#import "RTTestCommon.h"

#import "RTManageDevicesPresenter.h"
#import "RTManageDevicesView.h"

#import "RTPagedListInteractor.h"
#import "RTRevokeClientInteractor.h"

#import "RTClient.h"
#import "RTClientDescription.h"

SpecBegin(RTManageDevicesPresenter)

describe(@"manage devices presenter", ^{
    
    __block RTManageDevicesPresenter *presenter;
    __block id<RTManageDevicesView> view;
    
    __block RTPagedListInteractor *browseDevicesInteractor;
    __block RTRevokeClientInteractor *revokeClientInteractor;

    beforeEach(^{
        view = mockProtocol(@protocol(RTManageDevicesView));
        
        browseDevicesInteractor = mock([RTPagedListInteractor class]);
        revokeClientInteractor = mock([RTRevokeClientInteractor class]);
        
        presenter = [[RTManageDevicesPresenter alloc] initWithView:view
                                           browseDevicesInteractor:browseDevicesInteractor
                                            revokeClientInteractor:revokeClientInteractor];
    });
    
    describe(@"list reset", ^{
        it(@"should notify view that currently displayed descriptions should be removed", ^{
            [presenter clearPresentedItems];
            [verify(view) clearClientDescriptions];
        });
    });
    
    describe(@"show client description", ^{
        it(@"should show client description", ^{
            RTClient *client = [[RTClient alloc] initWithClientId:clientId
                                                       clientName:clientName];
            [presenter presentItem:client];
            
            MKTArgumentCaptor *captor = [[MKTArgumentCaptor alloc] init];
            [verify(view) showClientDescription:[captor capture]];
            
            RTClientDescription *description = [captor value];
            expect(description).toNot.beNil();
            
            expect(description.clientId).to.equal(clientId);
            expect(description.clientName).to.equal(clientName);
        });
    });
    
    describe(@"requested client revocation", ^{
        it(@"should pass client id to interactor", ^{
            [presenter requestedRevocationForClientWithClientId:clientId];
            [verify(revokeClientInteractor) revokeClientWithClientId:clientId];
        });
    });
});

SpecEnd