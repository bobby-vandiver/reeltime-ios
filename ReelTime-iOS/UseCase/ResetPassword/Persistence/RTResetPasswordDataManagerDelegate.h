#import <Foundation/Foundation.h>

@protocol RTResetPasswordDataManagerDelegate <NSObject>

- (void)submitRequestForResetPasswordEmailFailedWithErrors:(NSArray *)errors;

- (void)failedToResetPasswordWithErrors:(NSArray *)errors;

@end
