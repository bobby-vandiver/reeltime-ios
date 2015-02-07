#import <Foundation/Foundation.h>

@protocol RTAccountRegistrationDataManagerDelegate;

@class RTServerErrorsConverter;

@class RTClient;
@class RTClientCredentialsStore;

@class RTAccountRegistration;
@class RTClientCredentials;

@interface RTAccountRegistrationDataManager : NSObject

- (instancetype)initWithDelegate:(id<RTAccountRegistrationDataManagerDelegate>)delegate
                          client:(RTClient *)client
           serverErrorsConverter:(RTServerErrorsConverter *)serverErrorsConverter
          clientCredentialsStore:(RTClientCredentialsStore *)clientCredentialsStore;

- (void)registerAccount:(RTAccountRegistration *)registration
               callback:(void (^)(RTClientCredentials *clientCredentials))callback;

- (void)saveClientCredentials:(RTClientCredentials *)clientCredentials
                  forUsername:(NSString *)username
                     callback:(void (^)())callback;

@end
