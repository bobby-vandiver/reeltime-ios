#import <Foundation/Foundation.h>

@protocol RTDeviceRegistrationDataManagerDelegate;

@class RTClient;

@class RTServerErrorsConverter;
@class RTClientCredentialsStore;

@class RTUserCredentials;
@class RTClientCredentials;

@interface RTDeviceRegistrationDataManager : NSObject

- (instancetype)initWithDelegate:(id<RTDeviceRegistrationDataManagerDelegate>)delegate
                          client:(RTClient *)client
           serverErrorsConverter:(RTServerErrorsConverter *)serverErrorsConverter
          clientCredentialsStore:(RTClientCredentialsStore *)clientCredentialsStore;

- (void)fetchClientCredentialsForClientName:(NSString *)clientName
                        withUserCredentials:(RTUserCredentials *)userCredentials
                                   callback:(void (^)(RTClientCredentials *clientCredentials))callback;

- (void)storeClientCredentials:(RTClientCredentials *)clientCredentials
                   forUsername:(NSString *)username
                      callback:(void(^)())callback;

@end
