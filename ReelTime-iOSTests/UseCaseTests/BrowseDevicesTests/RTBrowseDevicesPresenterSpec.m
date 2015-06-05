#import "RTTestCommon.h"

#import "RTBrowseDevicesPresenter.h"

#import "RTBrowseDevicesView.h"
#import "RTPagedListInteractor.h"

#import "RTClient.h"
#import "RTClientDescription.h"

SpecBegin(RTBrowseDevicesPresenter)

describe(@"browse clients presenter", ^{

    __block RTBrowseDevicesPresenter *presenter;
    
    __block id<RTBrowseDevicesView> view;
    __block RTPagedListInteractor *interactor;
    
    beforeEach(^{
        view = mockProtocol(@protocol(RTBrowseDevicesView));
        interactor = mock([RTPagedListInteractor class]);
        
        presenter = [[RTBrowseDevicesPresenter alloc] initWithView:view
                                                        interactor:interactor];
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
});

SpecEnd
