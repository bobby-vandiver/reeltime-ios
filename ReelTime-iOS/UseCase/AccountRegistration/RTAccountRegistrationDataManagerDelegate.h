#import <Foundation/Foundation.h>

@class RTClientCredentials;

@protocol RTAccountRegistrationDataManagerDelegate <NSObject>

- (void)registerAccountFailedWithErrors:(NSArray *)errors;

- (void)failedToSaveClientCredentials:(RTClientCredentials *)clientCredentials
                          forUsername:(NSString *)username;

@end
