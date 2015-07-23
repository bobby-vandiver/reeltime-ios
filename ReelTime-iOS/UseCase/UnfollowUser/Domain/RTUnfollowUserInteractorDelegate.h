#import <Foundation/Foundation.h>

@protocol RTUnfollowUserInteractorDelegate <NSObject>

- (void)unfollowUserSucceededForUsername:(NSString *)username;

- (void)unfollowUserFailedForUsername:(NSString *)username
                            withError:(NSError *)error;
@end
