#ifndef ReelTime_iOS_RTClientErrors_h
#define ReelTime_iOS_RTClientErrors_h

#import <Foundation/Foundation.h>

extern NSString *const RTClientTokenErrorDomain;

typedef NS_ENUM(NSInteger, ReelTimeClientTokenErrors) {
    Unauthorized,
    InvalidClientCredentials,
    InvalidUserCredentials
};

#endif

