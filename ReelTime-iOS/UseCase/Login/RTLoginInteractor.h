#import <Foundation/Foundation.h>

#import "RTLoginPresenter.h"
#import "RTClientCredentialsStore.h"

@interface RTLoginInteractor : NSObject

- (instancetype)initWithPresenter:(RTLoginPresenter *)presenter
           clientCredentialsStore:(RTClientCredentialsStore *)clientCredentialsStore;

- (void)loginWithUsername:(NSString *)username
                 password:(NSString *)password;

@end
