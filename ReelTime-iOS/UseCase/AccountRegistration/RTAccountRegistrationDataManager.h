#import <Foundation/Foundation.h>

@class RTAccountRegistrationInteractor;
@class RTClient;
@class RTClientCredentialsStore;

@class RTAccountRegistration;
@class RTClientCredentials;

@interface RTAccountRegistrationDataManager : NSObject

- (instancetype)initWithInteractor:(RTAccountRegistrationInteractor *)interactor
                            client:(RTClient *)client
            clientCredentialsStore:(RTClientCredentialsStore *)clientCredentialsStore;

- (void)registerAccount:(RTAccountRegistration *)registration
               callback:(void (^)(RTClientCredentials *clientCredentials))callback;

- (void)saveClientCredentials:(RTClientCredentials *)clientCredentials
                  forUsername:(NSString *)username;

@end
