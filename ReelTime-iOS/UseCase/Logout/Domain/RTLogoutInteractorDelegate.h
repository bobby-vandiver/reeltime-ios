#import <Foundation/Foundation.h>

@protocol RTLogoutInteractorDelegate <NSObject>

- (void)logoutSucceeded;

- (void)logoutFailed;

@end
