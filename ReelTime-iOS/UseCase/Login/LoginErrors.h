//
//  LoginErrors.h
//  ReelTime-iOS
//
//  Created by Bobby Vandiver on 12/28/14.
//  Copyright (c) 2014 ReelTime. All rights reserved.
//

#import <Foundation/Foundation.h>

NSString *const LoginErrorsDomain = @"in.reeltime.Login";

typedef NS_ENUM(NSInteger, LoginErrors) {
    UnknownClient,
    InvalidCredentials
};