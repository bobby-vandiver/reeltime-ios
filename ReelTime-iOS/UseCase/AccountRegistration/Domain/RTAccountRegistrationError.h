#import <Foundation/Foundation.h>

extern NSString *const RTAccountRegistrationErrorDomain;

typedef NS_ENUM(NSInteger, RTAccountRegistrationError) {
    RTAccountRegistrationErrorMissingUsername,
    RTAccountRegistrationErrorMissingPassword,
    RTAccountRegistrationErrorMissingConfirmationPassword,
    RTAccountRegistrationErrorMissingEmail,
    RTAccountRegistrationErrorMissingDisplayName,
    RTAccountRegistrationErrorMissingClientName,
    
    RTAccountRegistrationErrorInvalidUsername,
    RTAccountRegistrationErrorInvalidPassword,
    RTAccountRegistrationErrorInvalidEmail,
    RTAccountRegistrationErrorInvalidDisplayName,
    
    RTAccountRegistrationErrorUsernameIsUnavailable,
    RTAccountRegistrationErrorConfirmationPasswordDoesNotMatch,
    
    RTAccountRegistrationErrorRegistrationServiceUnavailable,
    RTAccountRegistrationErrorUnableToAssociateClientWithDevice
};