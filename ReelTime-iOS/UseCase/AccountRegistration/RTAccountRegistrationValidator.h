#import <Foundation/Foundation.h>

@class RTAccountRegistration;

@interface RTAccountRegistrationValidator : NSObject

- (BOOL)validateAccountRegistration:(RTAccountRegistration *)registration
                             errors:(NSArray *__autoreleasing *)errors;

@end
