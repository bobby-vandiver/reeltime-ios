#import <Foundation/Foundation.h>

@class RTClientCredentials;
@class RTClientCredentialsStore;

@interface RTClientCredentialsService : NSObject

- (instancetype)initWithClientCredentialsStore:(RTClientCredentialsStore *)clientCredentialsStore;

- (void)saveClientCredentials:(RTClientCredentials *)clientCredentials
                  forUsername:(NSString *)username
                      success:(void (^)())success
                      failure:(void (^)(NSError *error))failure;

@end
