#import <Foundation/Foundation.h>
#import "RTCallbacks.h"

@class RTClientCredentials;
@class RTClientCredentialsStore;

@interface RTClientCredentialsService : NSObject

- (instancetype)initWithClientCredentialsStore:(RTClientCredentialsStore *)clientCredentialsStore;

- (void)saveClientCredentials:(RTClientCredentials *)clientCredentials
                  forUsername:(NSString *)username
                      success:(NoArgsCallback)success
                      failure:(ErrorCallback)failure;

@end
