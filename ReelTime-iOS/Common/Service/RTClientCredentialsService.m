#import "RTClientCredentialsService.h"
#import "RTClientCredentialsStore.h"

@interface RTClientCredentialsService ()

@property RTClientCredentialsStore *clientCredentialsStore;

@end

@implementation RTClientCredentialsService

- (instancetype)initWithClientCredentialsStore:(RTClientCredentialsStore *)clientCredentialsStore {
    self = [super init];
    if (self) {
        self.clientCredentialsStore = clientCredentialsStore;
    }
    return self;
}

- (void)saveClientCredentials:(RTClientCredentials *)clientCredentials
                  forUsername:(NSString *)username
                      success:(void (^)())success
                      failure:(void (^)(NSError *))failure {
    NSError *error;
    BOOL successful = [self.clientCredentialsStore storeClientCredentials:clientCredentials
                                                              forUsername:username
                                                                    error:&error];
    successful ? success() : failure(error);
}

@end
