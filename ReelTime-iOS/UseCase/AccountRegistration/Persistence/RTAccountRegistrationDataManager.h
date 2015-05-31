#import <Foundation/Foundation.h>
#import "RTCallback.h"

@protocol RTAccountRegistrationDataManagerDelegate;

@class RTAPIClient;
@class RTClientCredentialsStore;

@class RTAccountRegistration;
@class RTClientCredentials;

@interface RTAccountRegistrationDataManager : NSObject

- (instancetype)initWithDelegate:(id<RTAccountRegistrationDataManagerDelegate>)delegate
                          client:(RTAPIClient *)client
          clientCredentialsStore:(RTClientCredentialsStore *)clientCredentialsStore;

- (void)registerAccount:(RTAccountRegistration *)registration
               callback:(ClientCredentialsCallback)callback;

// TODO: Refactor to use the RTClientCredentialsService instead
- (void)saveClientCredentials:(RTClientCredentials *)clientCredentials
                  forUsername:(NSString *)username
                     callback:(NoArgsCallback)callback;

@end
