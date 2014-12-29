//
//  LoginErrors.h
//  ReelTime-iOS
//
//  Created by Bobby Vandiver on 12/28/14.
//  Copyright (c) 2014 ReelTime. All rights reserved.
//

#ifndef ReelTime_iOS_LoginErrors_h
#define ReelTime_iOS_LoginErrors_h

#import <Foundation/Foundation.h>

NSString *const LoginErrorsDomain = @"in.reeltime.Login";

typedef NS_ENUM(NSInteger, LoginErrors) {
    UnknownClient,
    InvalidCredentials
};

#endif