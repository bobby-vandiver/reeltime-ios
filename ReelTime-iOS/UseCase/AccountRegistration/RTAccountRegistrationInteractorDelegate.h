#import <Foundation/Foundation.h>

@protocol RTAccountRegistrationInteractorDelegate <NSObject>

- (void)registrationWithAutoLoginSucceeded;

- (void)registrationWithAutoLoginFailedWithErrors:(NSArray *)errors;

- (void)registrationFailedWithErrors:(NSArray *)errors;

@end
