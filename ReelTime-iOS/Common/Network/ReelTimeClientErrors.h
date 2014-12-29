//
//  ReelTimeClientErrors.h
//  ReelTime-iOS
//
//  Created by Bobby Vandiver on 12/28/14.
//  Copyright (c) 2014 ReelTime. All rights reserved.
//

#ifndef ReelTime_iOS_ReelTimeClientErrors_h
#define ReelTime_iOS_ReelTimeClientErrors_h

#import <Foundation/Foundation.h>

extern NSString *const ReelTimeClientTokenErrorDomain;

typedef NS_ENUM(NSInteger, ReelTimeClientTokenErrors) {
    Unauthorized,
    InvalidClientCredentials,
    InvalidUserCredentials
};

#endif

