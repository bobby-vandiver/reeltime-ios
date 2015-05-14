#import <Foundation/Foundation.h>

@protocol RTAccountRegistrationDataManagerDelegate;

@class RTClient;
@class RTClientCredentialsStore;

@class RTAccountRegistration;
@class RTClientCredentials;

@interface RTAccountRegistrationDataManager : NSObject

- (instancetype)initWithDelegate:(id<RTAccountRegistrationDataManagerDelegate>)delegate
                          client:(RTClient *)client
          clientCredentialsStore:(RTClientCredentialsStore *)clientCredentialsStore;

- (void)registerAccount:(RTAccountRegistration *)registration
               callback:(void (^)(RTClientCredentials *clientCredentials))callback;

// TODO: Refactor to use the RTClientCredentialsService instead
- (void)saveClientCredentials:(RTClientCredentials *)clientCredentials
                  forUsername:(NSString *)username
                     callback:(void (^)())callback;

@end
