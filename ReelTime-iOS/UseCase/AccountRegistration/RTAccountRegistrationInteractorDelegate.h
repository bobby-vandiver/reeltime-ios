#import <Foundation/Foundation.h>

@protocol RTAccountRegistrationInteractorDelegate <NSObject>

- (void)registrationWithAutoLoginFailedWithError:(NSError *)error;

- (void)registrationFailedWithErrors:(NSArray *)errors;

@end
