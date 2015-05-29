#import <Foundation/Foundation.h>

@protocol RTConfirmAccountInteractorDelegate <NSObject>

- (void)confirmationEmailSent;

- (void)confirmationEmailFailedWithErrors:(NSArray *)errors;

- (void)confirmAccountSucceeded;

- (void)confirmAccountFailedWithErrors:(NSArray *)errors;

@end
