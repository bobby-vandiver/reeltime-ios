#import <Foundation/Foundation.h>

extern NSString *const RTChangeDisplayNameErrorDomain;

typedef NS_ENUM(NSInteger, RTChangeDisplayNameError) {
    RTChangeDisplayNameErrorMisingDisplayName,
    RTChangeDisplayNameErrorInvalidDisplayName
};