#import <Foundation/Foundation.h>

@protocol RTResetPasswordDataManagerDelegate <NSObject>

- (void)sendResetEmailFailedWithErrors:(NSArray *)errors;

@end
