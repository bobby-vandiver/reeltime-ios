//
//  LoginInteractorSpec.m
//  ReelTime-iOS
//
//  Created by Bobby Vandiver on 12/28/14.
//  Copyright (c) 2014 ReelTime. All rights reserved.
//

#import "Common.h"
#import "LoginInteractor.h"
#import "LoginErrors.h"

SpecBegin(LoginInteractor)

describe(@"login logic", ^{
    
    __block LoginInteractor *interactor;
    __block LoginPresenter *presenter;

    __block ClientCredentialsStore *clientCredentialsStore;
    __block ClientCredentials *clientCredentials;
    
    __block NSString *username = @"someone";
    __block NSString *password = @"secret";
    
    beforeEach(^{
        clientCredentialsStore = mock([ClientCredentialsStore class]);
        clientCredentials = [[ClientCredentials alloc] initWithClientId:@"foo"
                                                           clientSecret:@"bar"];
        
        presenter = mock([LoginPresenter class]);
        interactor = [[LoginInteractor alloc] initWithPresenter:presenter
                                         clientCredentialsStore:clientCredentialsStore];
    });
    
    describe(@"successful login", ^{

        before(^{
            [given([clientCredentialsStore loadClientCredentials]) willReturn:clientCredentials];
        });
        
        it(@"notify presenter of success", ^{
            [interactor loginWithUsername:username password:password];
            [verify(presenter) loginSucceeded];
        });
    });
    
    describe(@"failed login", ^{
       
        context(@"client credentials not found", ^{
            
            before(^{
                [given([clientCredentialsStore loadClientCredentials]) willReturn:nil];
            });
            
            it(@"notify presenter of unknown client", ^{
                [interactor loginWithUsername:username password:password];

                MKTArgumentCaptor *errorCaptor = [[MKTArgumentCaptor alloc] init];
                [verify(presenter) loginFailedWithError:[errorCaptor capture]];

                expect([errorCaptor value]).to.beKindOf([NSError class]);
                
                NSError *error = [errorCaptor value];
                expect(error.domain).to.equal(LoginErrorsDomain);
                expect(error.code).to.equal(UnknownClient);
            });
        });
    });
});

SpecEnd