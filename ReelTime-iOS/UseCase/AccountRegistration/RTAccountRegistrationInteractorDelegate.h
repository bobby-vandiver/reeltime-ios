#import <Foundation/Foundation.h>

@protocol RTAccountRegistrationInteractorDelegate <NSObject>

- (void)registrationWithAutoLoginSucceeded;

- (void)registrationWithAutoLoginFailedWithError:(NSError *)error;

- (void)registrationFailedWithErrors:(NSArray *)errors;

@end
