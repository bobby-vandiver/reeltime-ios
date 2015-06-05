#import "RTTestCommon.h"

#import "RTBrowseClientsDataManager.h"
#import "RTAPIClient.h"

#import "RTClient.h"
#import "RTClientList.h"

SpecBegin(RTBrowseClientsDataManager)

describe(@"browse clients data manager", ^{
    
    __block RTBrowseClientsDataManager *dataManager;
    __block RTAPIClient *client;
    
    __block MKTArgumentCaptor *successCaptor;
    __block MKTArgumentCaptor *failureCaptor;
    
    beforeEach(^{
        client = mock([RTAPIClient class]);
        dataManager = [[RTBrowseClientsDataManager alloc] initWithClient:client];
        
        successCaptor = [[MKTArgumentCaptor alloc] init];
        failureCaptor = [[MKTArgumentCaptor alloc] init];
    });
    
    describe(@"retrieving a clients list page", ^{
        __block RTCallbackTestExpectation *pageRetrieved;
        
        beforeEach(^{
            pageRetrieved = [RTCallbackTestExpectationFactory arrayCallback];
            [dataManager retrievePage:pageNumber callback:pageRetrieved.callback];
 
            [verify(client) listClientsPage:pageNumber
                                    success:[successCaptor capture]
                                    failure:[failureCaptor capture]];
            
            [pageRetrieved expectCallbackNotExecuted];
        });
        
        it(@"should pass clients page to callback on success", ^{
            RTClient *client = [[RTClient alloc] init];
            
            client.clientId = @"cid";
            client.clientName = @"cname";
            
            RTClientList *clientList = [[RTClientList alloc] init];
            clientList.clients = @[client];
            
            ClientListCallback successHandler = [successCaptor value];
            successHandler(clientList);
            
            [pageRetrieved expectCallbackExecuted];
            
            NSArray *callbackClients = pageRetrieved.callbackArguments;

            expect(callbackClients).toNot.beNil();
            expect(callbackClients).to.haveACountOf(1);
            
            RTClient *retrieved = callbackClients[0];
            
            expect(retrieved.clientId).to.equal(@"cid");
            expect(retrieved.clientName).to.equal(@"cname");
        });
        
        it(@"should pass empty list to callback on failure", ^{
            ServerErrorsCallback failureHandler = [failureCaptor value];
            failureHandler(nil);
            
            [pageRetrieved expectCallbackExecuted];
            
            NSArray *callbackClients = pageRetrieved.callbackArguments;

            expect(callbackClients).toNot.beNil();
            expect(callbackClients).to.haveACountOf(0);
        });
    });
});

SpecEnd
