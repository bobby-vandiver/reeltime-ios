#import "RTTestCommon.h"

#import "RTChangePasswordDataManager.h"
#import "RTChangePasswordDataManagerDelegate.h"

#import "RTClient.h"

SpecBegin(RTChangePasswordDataManager)

describe(@"change password data manager", ^{
    
    __block RTChangePasswordDataManager *dataManager;
    __block id<RTChangePasswordDataManagerDelegate> delegate;
    
    __block RTClient *client;
    
    beforeEach(^{
        client = mock([RTClient class]);
        delegate = mockProtocol(@protocol(RTChangePasswordDataManagerDelegate));
        dataManager = [[RTChangePasswordDataManager alloc] initWithDelegate:delegate client:client];
    });
    
    describe(@"changing password", ^{
        __block BOOL callbackExecuted;
        
        void (^callback)() = ^{
            callbackExecuted = YES;
        };
        
        beforeEach(^{
            callbackExecuted = NO;
            [dataManager changePassword:password callback:callback];
        });
        
        it(@"should invoke callback on successful change", ^{
            MKTArgumentCaptor *successCaptor = [[MKTArgumentCaptor alloc] init];
            
            [verify(client) changePassword:password
                                   success:[successCaptor capture]
                                   failure:anything()];
            
            expect(callbackExecuted).to.beFalsy();
            
            NoArgsCallback successHandler = [successCaptor value];
            successHandler();
            
            expect(callbackExecuted).to.beTruthy();
        });
    });
});

SpecEnd