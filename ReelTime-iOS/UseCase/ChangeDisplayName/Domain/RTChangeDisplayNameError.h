#import <Foundation/Foundation.h>

extern NSString *const RTChangeDisplayNameErrorDomain;

typedef NS_ENUM(NSInteger, RTChangeDisplayNameError) {
    RTChangeDisplayNameErrorMissingDisplayName,
    RTChangeDisplayNameErrorInvalidDisplayName,
    RTChangeDisplayNameErrorUnknownError
};