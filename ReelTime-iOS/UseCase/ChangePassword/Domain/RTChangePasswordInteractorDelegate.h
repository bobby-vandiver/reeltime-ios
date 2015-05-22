#import <Foundation/Foundation.h>

@protocol RTChangePasswordInteractorDelegate <NSObject>

- (void)changePasswordSucceeded;

- (void)changePasswordFailedWithErrors:(NSArray *)errors;

@end
