#import <Foundation/Foundation.h>

@protocol RTResetPasswordInteractorDelegate <NSObject>

- (void)resetPasswordEmailSent;

- (void)resetPasswordEmailFailedWithErrors:(NSArray *)errors;

- (void)resetPasswordSucceeded;

- (void)resetPasswordFailedWithErrors:(NSArray *)errors;

@end
