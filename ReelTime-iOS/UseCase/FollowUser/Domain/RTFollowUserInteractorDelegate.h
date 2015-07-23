#import <Foundation/Foundation.h>

@protocol RTFollowUserInteractorDelegate <NSObject>

- (void)followUserSucceededForUsername:(NSString *)username;

- (void)followUserFailedForUsername:(NSString *)username
                          withError:(NSError *)error;

@end
