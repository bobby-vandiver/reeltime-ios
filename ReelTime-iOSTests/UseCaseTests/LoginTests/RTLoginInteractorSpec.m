#import "RTTestCommon.h"
#import "RTLoginInteractor.h"
#import "RTLoginErrors.h"

SpecBegin(RTLoginInteractor)

describe(@"login logic", ^{
    
    __block RTLoginInteractor *interactor;
    __block RTLoginPresenter *presenter;

    __block RTClientCredentialsStore *clientCredentialsStore;
    __block RTClientCredentials *clientCredentials;
    
    __block NSString *username = @"someone";
    __block NSString *password = @"secret";
    
    beforeEach(^{
        clientCredentialsStore = mock([RTClientCredentialsStore class]);
        clientCredentials = [[RTClientCredentials alloc] initWithClientId:@"foo"
                                                           clientSecret:@"bar"];
        
        presenter = mock([RTLoginPresenter class]);
        interactor = [[RTLoginInteractor alloc] initWithPresenter:presenter
                                         clientCredentialsStore:clientCredentialsStore];
    });
    
    context(@"client credentials found", ^{
        
        beforeEach(^{
            [given([clientCredentialsStore loadClientCredentials]) willReturn:clientCredentials];
        });
        
        afterEach(^{
            [verify(clientCredentialsStore) loadClientCredentials];
        });
        
        it(@"notify presenter of successful login", ^{
            [interactor loginWithUsername:username password:password];
            [verify(presenter) loginSucceeded];
        });
    });
    
    context(@"client credentials not found", ^{
        before(^{
            [given([clientCredentialsStore loadClientCredentials]) willReturn:nil];
        });
        
        it(@"notify presenter of failed login due to unknown client", ^{
            [interactor loginWithUsername:username password:password];
            
            MKTArgumentCaptor *errorCaptor = [[MKTArgumentCaptor alloc] init];
            [verify(presenter) loginFailedWithError:[errorCaptor capture]];
            
            expect([errorCaptor value]).to.beKindOf([NSError class]);
            
            NSError *error = [errorCaptor value];
            expect(error.domain).to.equal(RTLoginErrorsDomain);
            expect(error.code).to.equal(UnknownClient);
        });
    });
});

SpecEnd