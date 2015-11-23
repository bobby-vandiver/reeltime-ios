#import <Foundation/Foundation.h>

extern NSString *const RTRemoveAccountErrorDomain;

typedef NS_ENUM(NSInteger, RTRemoveAccountError) {
    RTRemoveAccountErrorUnauthorized,
    RTRemoveAccountErrorUnknownError
};