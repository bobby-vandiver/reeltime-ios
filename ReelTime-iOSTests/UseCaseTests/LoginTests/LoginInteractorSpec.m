//
//  LoginInteractorSpec.m
//  ReelTime-iOS
//
//  Created by Bobby Vandiver on 12/28/14.
//  Copyright (c) 2014 ReelTime. All rights reserved.
//

#import "Common.h"
#import "LoginInteractor.h"

SpecBegin(LoginInteractor)

describe(@"login logic", ^{
    
    __block LoginInteractor *interactor;
    __block LoginPresenter *presenter;

    __block ClientCredentialsStore *clientCredentialsStore;
    __block ClientCredentials *clientCredentials;
    
    __block NSString *username = @"someone";
    __block NSString *password = @"secret";
    
    beforeEach(^{
        clientCredentialsStore = OCMClassMock([ClientCredentialsStore class]);
        clientCredentials = [[ClientCredentials alloc] initWithClientId:@"foo"
                                                           clientSecret:@"bar"];
        
        presenter = OCMClassMock([LoginPresenter class]);
        interactor = [[LoginInteractor alloc] initWithPresenter:presenter
                                         clientCredentialsStore:clientCredentialsStore];
    });

    afterEach(^{
        OCMVerify([clientCredentialsStore loadClientCredentials]);
    });
    
    describe(@"successful login", ^{

        before(^{
            OCMStub([clientCredentialsStore loadClientCredentials]).andReturn(clientCredentials);
        });
        
        it(@"notify presenter of success", ^{
            [interactor loginWithUsername:username password:password];
            OCMVerify([presenter loginDidSucceed]);
        });
    });
    
    describe(@"failed login", ^{
       
        context(@"client credentials not found", ^{
            
            before(^{
                OCMStub([clientCredentialsStore loadClientCredentials]).andReturn(nil);
            });
            
            it(@"notify presenter of unknown client", ^{
                [interactor loginWithUsername:username password:password];
                OCMVerify([presenter loginDidFailWithUnknownClient]);
            });
        });
    });
});

SpecEnd