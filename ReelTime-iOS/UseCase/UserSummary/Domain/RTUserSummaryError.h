#import <Foundation/Foundation.h>

extern NSString *const RTUserSummaryErrorDomain;

typedef NS_ENUM(NSInteger, RTUserSummaryError) {
    RTUserSummaryErrorMissingUsername,
    RTUserSummaryErrorUserNotFound
};