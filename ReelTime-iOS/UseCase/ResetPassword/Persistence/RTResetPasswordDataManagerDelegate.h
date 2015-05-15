#import <Foundation/Foundation.h>

@protocol RTResetPasswordDataManagerDelegate <NSObject>

- (void)sendResetPasswordEmailFailedWithErrors:(NSArray *)errors;

@end
