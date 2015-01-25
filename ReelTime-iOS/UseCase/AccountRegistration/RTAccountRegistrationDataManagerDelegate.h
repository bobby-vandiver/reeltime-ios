#import <Foundation/Foundation.h>

@class RTClientCredentials;

@protocol RTAccountRegistrationDataManagerDelegate <NSObject>

- (void)accountRegistrationDataOperationFailedWithErrors:(NSArray *)errors;

- (void)unableToSaveClientCredentials:(RTClientCredentials *)clientCredentials
                          forUsername:(NSString *)username;

@end
