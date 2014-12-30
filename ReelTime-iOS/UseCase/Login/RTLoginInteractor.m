#import "RTLoginInteractor.h"
#import "RTLoginErrors.h"

@interface RTLoginInteractor ()

@property RTLoginPresenter *presenter;
@property RTClientCredentialsStore *clientCredentialsStore;

@end

@implementation RTLoginInteractor

- (instancetype)initWithPresenter:(RTLoginPresenter *)presenter
           clientCredentialsStore:(RTClientCredentialsStore *)clientCredentialsStore {
    self = [super init];
    if (self) {
        self.presenter = presenter;
        self.clientCredentialsStore = clientCredentialsStore;
    }
    return self;
}

- (void)loginWithUsername:(NSString *)username
                 password:(NSString *)password {
    RTClientCredentials *clientCredentials = [self.clientCredentialsStore loadClientCredentials];

    if (!clientCredentials) {
        NSError *unknownClientError = [NSError errorWithDomain:RTLoginErrorsDomain
                                                          code:UnknownClient
                                                      userInfo:nil];
     
        [self.presenter loginFailedWithError:unknownClientError];
        return;
    }

    [self.presenter loginSucceeded];
}

@end
