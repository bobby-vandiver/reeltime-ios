#import "RTValidator.h"

@class RTAccountRegistration;

@interface RTAccountRegistrationValidator : RTValidator

- (BOOL)validateAccountRegistration:(RTAccountRegistration *)registration
                             errors:(NSArray *__autoreleasing *)errors;

@end
