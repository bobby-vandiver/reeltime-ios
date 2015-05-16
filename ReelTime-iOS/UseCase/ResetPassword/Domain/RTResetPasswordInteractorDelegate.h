#import <Foundation/Foundation.h>

@protocol RTResetPasswordInteractorDelegate <NSObject>

- (void)resetPasswordEmailSent;

- (void)resetPasswordEmailFailedWithErrors:(NSArray *)errors;

@end
