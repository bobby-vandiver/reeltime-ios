#import "RTTestCommon.h"
#import "RTLoginInteractor.h"

SpecBegin(RTLoginInteractor)

describe(@"login interactor", ^{
    
    __block RTLoginInteractor *interactor;
    __block RTLoginPresenter *presenter;

    __block RTClient *client;
    
    __block RTClientCredentialsStore *clientCredentialsStore;
    __block RTClientCredentials *clientCredentials;
    
    __block NSString *username = @"someone";
    __block NSString *password = @"secret";
       
    beforeEach(^{
        clientCredentialsStore = mock([RTClientCredentialsStore class]);
        clientCredentials = [[RTClientCredentials alloc] initWithClientId:@"foo"
                                                           clientSecret:@"bar"];
        
        presenter = mock([RTLoginPresenter class]);
        client = mock([RTClient class]);
        
        interactor = [[RTLoginInteractor alloc] initWithPresenter:presenter
                                                           client:client
                                           clientCredentialsStore:clientCredentialsStore];
    });
    
    context(@"client credentials found", ^{
        
        beforeEach(^{
            [given([clientCredentialsStore loadClientCredentials]) willReturn:clientCredentials];
        });
        
        afterEach(^{
            [verify(clientCredentialsStore) loadClientCredentials];
        });
        
        it(@"should notify presenter of successful login", ^{
            [interactor loginWithUsername:username password:password];
            [verify(presenter) loginSucceeded];
        });
    });
    
    context(@"client credentials not found", ^{
        before(^{
            [given([clientCredentialsStore loadClientCredentials]) willReturn:nil];
        });
        
        it(@"should notify presenter of failed login due to unknown client", ^{
            [interactor loginWithUsername:username password:password];
            
            MKTArgumentCaptor *errorCaptor = [[MKTArgumentCaptor alloc] init];
            [verify(presenter) loginFailedWithError:[errorCaptor capture]];
            
            expect([errorCaptor value]).to.beError(RTLoginErrorsDomain, UnknownClient);
        });
    });
});

SpecEnd