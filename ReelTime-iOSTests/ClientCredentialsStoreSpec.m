//
//  ClientCredentialsStoreSpec.m
//  ReelTime-iOS
//
//  Created by Bobby Vandiver on 12/27/14.
//  Copyright (c) 2014 ReelTime. All rights reserved.
//

#import "Common.h"
#import "ClientCredentialsStore.h"

SpecBegin(ClientCredentialsStore)

describe(@"client credentials store", ^{
    
    __block ClientCredentialsStore *store;
    __block UICKeyChainStore *mockKeyChainStore;
    
    beforeEach(^{
        mockKeyChainStore = OCMClassMock([UICKeyChainStore class]);
        store = [[ClientCredentialsStore alloc] initWithKeyChainStore:mockKeyChainStore];
    });
    
    it(@"credentials not found", ^{
        ClientCredentials *credentials = [store loadClientCredentials];
        expect(credentials).to.beNil;
    });
});

SpecEnd

