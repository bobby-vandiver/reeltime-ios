#import "RTTestCommon.h"

#import "RTPagedListDataManager.h"
#import "RTAPIClient.h"
#import "RTException.h"

SpecBegin(RTPagedListDataManager)

describe(@"paged list data manager", ^{
    
    __block RTPagedListDataManager *dataManager;
    
    beforeEach(^{
        RTAPIClient *client = mock([RTAPIClient class]);
        dataManager = [[RTPagedListDataManager alloc] initWithClient:client];
    });
    
    it(@"should now allow abstract method to be invoked", ^{
        expect(^{
            [dataManager retrievePage:0 callback:anything()];
        }).to.raiseWithReason(RTAbstractMethodException, @"Cannot invoke abstract method");
    });
});

SpecEnd