#import "RTAccountRegistrationValidator.h"
#import "RTAccountRegistration.h"

#import "RTErrorFactory.h"

@implementation RTAccountRegistrationValidator

- (BOOL)validateAccountRegistration:(RTAccountRegistration *)registration
                             errors:(NSArray *__autoreleasing *)errors {
    BOOL valid = YES;
    NSMutableArray *errorContainer = [NSMutableArray array];
    
    if ([registration.username length] > 0) {
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^\\w{2,15}$"
                                                                               options:0
                                                                                 error:nil];
        
        NSUInteger matches = [regex numberOfMatchesInString:registration.username
                                                    options:0
                                                      range:NSMakeRange(0, [registration.username length])];
        if (matches < 1) {
            [self addRegistrationErrorCode:AccountRegistrationInvalidUsername toErrors:errorContainer];
        }
    }
    else if([registration.username length] == 0) {
        [self addRegistrationErrorCode:AccountRegistrationMissingUsername toErrors:errorContainer];
    }
    if([registration.password length] == 0) {
        [self addRegistrationErrorCode:AccountRegistrationMissingPassword toErrors:errorContainer];
    }
    if ([registration.confirmationPassword length] == 0) {
        [self addRegistrationErrorCode:AccountRegistrationMissingConfirmationPassword toErrors:errorContainer];
    }
    if ([registration.email length] == 0) {
        [self addRegistrationErrorCode:AccountRegistrationMissingEmail toErrors:errorContainer];
    }
    if ([registration.displayName length] == 0) {
        [self addRegistrationErrorCode:AccountRegistrationMissingDisplayName toErrors:errorContainer];
    }
    if ([registration.clientName length] == 0) {
        [self addRegistrationErrorCode:AccountRegistrationMissingClientName toErrors:errorContainer];
    }
    
    if ([errorContainer count] > 0) {
        valid = NO;
        
        if (errors) {
            *errors = errorContainer;
        }
    }
    
    return valid;
}

- (void)addRegistrationErrorCode:(RTAccountRegistrationErrors)code
                        toErrors:(NSMutableArray *)errors {
    NSError *error = [RTErrorFactory accountRegistrationErrorWithCode:code];
    [errors addObject:error];
}

@end
