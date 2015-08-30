#import <Foundation/Foundation.h>

extern NSString *const RTConfirmAccountErrorDomain;

typedef NS_ENUM(NSInteger, RTConfirmAccountError) {
    RTConfirmAccountErrorMissingConfirmationCode,
    RTConfirmAccountErrorInvalidConfirmationCode,
    RTConfirmAccountErrorEmailFailure,
    RTConfirmAccountErrorUnknownError
};