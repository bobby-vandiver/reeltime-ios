#import "RTFakeClient.h"

@implementation RTFakeClient

- (void)tokenWithClientCredentials:(RTClientCredentials *)clientCredentials
                   userCredentials:(RTUserCredentials *)userCredentials
                           success:(TokenSuccessHandler)successHandler
                           failure:(TokenFailureHandler)failureHandler {
    if (self.tokenShouldSucceed) {
        successHandler(self.token);
    }
    else {
        NSError *error = [NSError errorWithDomain:RTClientTokenErrorDomain
                                             code:self.tokenErrorCode
                                         userInfo:nil];
        failureHandler(error);
    }
}

@end
