#import "RTTestCommon.h"

#import "RTManageDevicesViewController.h"
#import "RTManageDevicesPresenter.h"

#import "RTArrayDataSource.h"
#import "RTClientDescription.h"

@interface RTManageDevicesViewController (Test)

@property RTArrayDataSource *devicesDataSource;

@end

SpecBegin(RTManageDevicesViewController)

describe(@"manage devices view controller", ^{
    
    __block RTManageDevicesViewController *viewController;
    __block RTManageDevicesPresenter *presenter;

    __block RTClientDescription *clientDescription1;
    __block RTClientDescription *clientDescription2;

    __block UITableView *tableView;
    
    beforeEach(^{
        presenter = mock([RTManageDevicesPresenter class]);
        viewController = [RTManageDevicesViewController viewControllerWithPresenter:presenter];

        tableView = mock([UITableView class]);
        viewController.clientListTableView = tableView;
        
        clientDescription1 = [RTClientDescription clientDescriptionWithClientId:clientId clientName:clientName];
        clientDescription2 = [RTClientDescription clientDescriptionWithClientId:@"otherId" clientName:@"otherName"];

        expect(viewController.devicesDataSource.items).to.haveACountOf(0);
    });
    
    describe(@"when view will appear", ^{
        it(@"should load the first page of clients", ^{
            [viewController viewWillAppear:anything()];
            [verify(presenter) requestedNextPage];
        });
    });
    
    context(@"should reload the table data after modifying the items in the data source", ^{
        afterEach(^{
            [verify(tableView) reloadData];
        });
    
        describe(@"show client description", ^{
            beforeEach(^{
                [viewController showClientDescription:clientDescription1];
            });
            
            it(@"should add description to data source", ^{
                expect(viewController.devicesDataSource.items).to.haveACountOf(1);
                expect(viewController.devicesDataSource.items).to.contain(clientDescription1);
            });
        });

        context(@"requires multiple descriptions", ^{
            beforeEach(^{
                [viewController showClientDescription:clientDescription1];
                [viewController showClientDescription:clientDescription2];
                [verify(tableView) reset];
            });
            
            describe(@"clear all client descriptions", ^{
                beforeEach(^{
                    [viewController clearClientDescriptions];
                });
                
                it(@"should remove all descriptions from the data source", ^{
                    expect(viewController.devicesDataSource.items).to.haveACountOf(0);
                });
            });
            
            describe(@"clear specific client description", ^{
                it(@"should remove only the specified description", ^{
                    [viewController clearClientDescriptionForClientId:clientDescription2.clientId];

                    expect(viewController.devicesDataSource.items).to.haveACountOf(1);
                    expect(viewController.devicesDataSource.items).to.contain(clientDescription1);
                });
            });
        });
    });
});

SpecEnd