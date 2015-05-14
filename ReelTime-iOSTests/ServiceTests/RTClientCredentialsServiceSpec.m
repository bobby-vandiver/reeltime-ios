#import "RTTestCommon.h"

#import "RTClientCredentialsService.h"

#import "RTClientCredentials.h"
#import "RTClientCredentialsStore.h"

SpecBegin(RTClientCredentialsService)

describe(@"client credentials service", ^{
    
    __block RTClientCredentialsService *service;

    __block RTClientCredentials *clientCredentials;
    __block RTClientCredentialsStore *clientCredentialsStore;
    
    beforeEach(^{
        clientCredentials = [[RTClientCredentials alloc] initWithClientId:clientId
                                                             clientSecret:clientSecret];
        
        clientCredentialsStore = mock([RTClientCredentialsStore class]);
        service = [[RTClientCredentialsService alloc] initWithClientCredentialsStore:clientCredentialsStore];
    });
    
    describe(@"saving client credentials", ^{
        __block RTClientCredentials *clientCredentials;

        __block BOOL successCallbackExecuted;
        __block BOOL failureCallbackExecuted;
        
        __block NSError *failureError;
        
        void (^successCallback)() = ^{
            successCallbackExecuted = YES;
        };
        
        void (^failureCallback)(NSError *) = ^(NSError *error) {
            failureCallbackExecuted = YES;
        };
        
        beforeEach(^{
            clientCredentials = [[RTClientCredentials alloc] initWithClientId:clientId
                                                                 clientSecret:clientSecret];
            successCallbackExecuted = NO;
            failureCallbackExecuted = NO;
            
            failureError = nil;
        });
        
        afterEach(^{
            [[verify(clientCredentialsStore) withMatcher:anything() forArgument:2]
             storeClientCredentials:clientCredentials forUsername:username error:nil];
        });
        
        it(@"should store client credentials and execute success callback", ^{
            [[given([clientCredentialsStore storeClientCredentials:clientCredentials forUsername:username error:nil])
              withMatcher:anything() forArgument:2]
             willReturnBool:YES];
            
            [service saveClientCredentials:clientCredentials
                               forUsername:username
                                   success:successCallback
                                   failure:failureCallback];
            
            expect(successCallbackExecuted).to.beTruthy();
            expect(failureCallbackExecuted).to.beFalsy();
        });
        
        it(@"should execute failure callback when unable to store client credentials", ^{
            [[given([clientCredentialsStore storeClientCredentials:clientCredentials forUsername:username error:nil])
              withMatcher:anything() forArgument:2]
             willReturnBool:NO];
            
            [service saveClientCredentials:clientCredentials
                               forUsername:username
                                   success:successCallback
                                   failure:failureCallback];

            expect(successCallbackExecuted).to.beFalsy();
            expect(failureCallbackExecuted).to.beTruthy();
        });
    });

});

SpecEnd
