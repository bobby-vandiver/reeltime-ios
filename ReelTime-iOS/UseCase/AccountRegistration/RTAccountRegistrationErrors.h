#import <Foundation/Foundation.h>

extern NSString *const RTAccountRegistrationErrorDomain;

typedef NS_ENUM(NSInteger, RTAccountRegistrationErrors) {
    AccountRegistrationMissingUsername,
    AccountRegistrationMissingPassword,
    AccountRegistrationMissingConfirmationPassword,
    AccountRegistrationMissingEmail,
    AccountRegistrationMissingDisplayName,
    AccountRegistrationMissingClientName,
    
    AccountRegistrationInvalidUsername,
    AccountRegistrationInvalidPassword,
    AccountRegistrationInvalidEmail,
    AccountRegistrationInvalidDisplayName,
    
    AccountRegistrationUsernameIsUnavailable,
    AccountRegistrationConfirmationPasswordDoesNotMatch,
    
    AccountRegistrationRegistrationServiceUnavailable
};
