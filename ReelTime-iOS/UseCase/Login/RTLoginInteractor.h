#import <Foundation/Foundation.h>

#import "RTLoginPresenter.h"
#import "RTClient.h"
#import "RTClientCredentialsStore.h"

#import "RTLoginErrors.h"

@interface RTLoginInteractor : NSObject

- (instancetype)initWithPresenter:(RTLoginPresenter *)presenter
                           client:(RTClient *)client
           clientCredentialsStore:(RTClientCredentialsStore *)clientCredentialsStore;

- (void)loginWithUsername:(NSString *)username
                 password:(NSString *)password;

@end
