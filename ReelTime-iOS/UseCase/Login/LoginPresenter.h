//
//  LoginPresenter.h
//  ReelTime-iOS
//
//  Created by Bobby Vandiver on 12/28/14.
//  Copyright (c) 2014 ReelTime. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginView.h"

@interface LoginPresenter : NSObject

- (instancetype)initWithView:(id<LoginView>)view;

- (void)requestedLoginWithUsername:(NSString *)username
                           password:(NSString *)password;

- (void)loginSucceeded;

- (void)loginFailedWithError:(NSError *)error;

@end
