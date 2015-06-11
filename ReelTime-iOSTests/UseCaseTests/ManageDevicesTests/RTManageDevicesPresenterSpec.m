#import "RTTestCommon.h"

#import "RTManageDevicesPresenter.h"
#import "RTManageDevicesView.h"

#import "RTPagedListInteractor.h"
#import "RTRevokeClientInteractor.h"

#import "RTClient.h"
#import "RTClientDescription.h"

#import "RTErrorFactory.h"

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
    
    describe(@"revocation succss", ^{
        it(@"should remove associated item", ^{
            RTClient *client = [[RTClient alloc] initWithClientId:clientId clientName:clientName];
            
            [presenter retrievedItems:@[client]];
            expect(presenter.items).to.haveACountOf(1);

            [presenter clientRevocationSucceededForClientWithClientId:clientId];
            
            [verify(view) clearClientDescriptionForClientId:clientId];
            expect(presenter.items).to.haveACountOf(0);
        });
    });
    
    describe(@"revocation failure", ^{
        __block RTErrorPresentationChecker *errorChecker;
        
        ErrorFactoryCallback errorFactoryCallback = ^NSError * (NSInteger code) {
            return [RTErrorFactory revokeClientErrorWithCode:code];
        };
        
        ArrayCallback errorsCallback = ^(NSArray *errors) {
            [presenter clientRevocationFailedForClientWithClientId:clientId errors:errors];
        };
        
        beforeEach(^{
            errorChecker = [[RTErrorPresentationChecker alloc] initWithView:view
                                                             errorsCallback:errorsCallback
                                                       errorFactoryCallback:errorFactoryCallback];
        });
        
        it(@"unknown client has associated item removed", ^{
            RTClient *client = [[RTClient alloc] initWithClientId:clientId clientName:clientName];

            [presenter retrievedItems:@[client]];
            expect(presenter.items).to.haveACountOf(1);
            
            [errorChecker verifyErrorMessage:@"Cannot revoke an unknown client"
                         isShownForErrorCode:RTRevokeClientErrorUnknownClient
                                   resetView:NO];
            
            [verify(view) clearClientDescriptionForClientId:clientId];
            expect(presenter.items).to.haveACountOf(0);
        });
        
        it(@"missing client id", ^{
            [errorChecker verifyNoErrorMessageIsShownForErrorCode:RTRevokeClientErrorMissingClientId];
        });
    });
});

SpecEnd