#import <Foundation/Foundation.h>

@class RTClientCredentials;

@interface RTClientCredentialsService : NSObject

- (void)saveClientCredentials:(RTClientCredentials *)clientCredentials
                  forUsername:(NSString *)username
                      success:(void (^)())success
                      failure:(void (^)(NSError *error))failure;

@end
