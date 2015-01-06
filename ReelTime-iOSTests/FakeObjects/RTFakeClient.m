#import "RTFakeClient.h"
#import "RTErrorFactory.h"

@implementation RTFakeClient

- (void)tokenWithClientCredentials:(RTClientCredentials *)clientCredentials
                   userCredentials:(RTUserCredentials *)userCredentials
                           success:(TokenSuccessHandler)successHandler
                           failure:(TokenFailureHandler)failureHandler {
    if (self.tokenShouldSucceed) {
        successHandler(self.token);
    }
    else {
        NSError *error = [RTErrorFactory clientTokenErrorWithCode:self.tokenErrorCode];
        failureHandler(error);
    }
}

@end
