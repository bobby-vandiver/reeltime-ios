#import "RTTestCommon.h"

#import "RTUserSummaryDataManager.h"
#import "RTUserSummaryDataManagerDelegate.h"

#import "RTClient.h"

SpecBegin(RTUserSummaryDataManager)

describe(@"user summary data manager", ^{
    
    __block RTUserSummaryDataManager *dataManager;
    
    __block id<RTUserSummaryDataManagerDelegate> delegate;
    __block RTClient *client;
    
    beforeEach(^{
        delegate = mockProtocol(@protocol(RTUserSummaryDataManagerDelegate));
        client = mock([RTClient class]);
        
        dataManager = [[RTUserSummaryDataManager alloc] initWithDelegate:delegate
                                                                  client:client];
    });
    
    describe(@"fetching user for username", ^{
        __block BOOL callbackExecuted;
        
        void (^callback)(RTUser *) = ^(RTUser *user) {
            callbackExecuted = YES;
        };
        
        beforeEach(^{
            callbackExecuted = NO;

            [dataManager fetchUserForUsername:username
                                     callback:callback];
        });
        
        it(@"should pass user to callback on success", ^{
            MKTArgumentCaptor *successCaptor = [[MKTArgumentCaptor alloc] init];
            
            [verify(client) userForUsername:username
                                    success:[successCaptor capture]
                                    failure:anything()];
            
            expect(callbackExecuted).to.beFalsy();
            
            UserCallback successHandler = [successCaptor value];
            successHandler(nil);
            
            expect(callbackExecuted).to.beTruthy();
        });
        
        it(@"should inform delegate when the user was not found", ^{
            MKTArgumentCaptor *failureCaptor = [[MKTArgumentCaptor alloc] init];
            
            [verify(client) userForUsername:username
                                    success:anything()
                                    failure:[failureCaptor capture]];
            
            [verifyCount(delegate, never()) userNotFound];
            
            ServerErrorsCallback failureHandler = [failureCaptor value];
            failureHandler(nil);
            
            [verify(delegate) userNotFound];
        });
    });
});

SpecEnd