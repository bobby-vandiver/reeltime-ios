//
//  LoginPresenter.m
//  ReelTime-iOS
//
//  Created by Bobby Vandiver on 12/28/14.
//  Copyright (c) 2014 ReelTime. All rights reserved.
//

#import "LoginPresenter.h"

@interface LoginPresenter ()

@property id<LoginView> view;

@end

@implementation LoginPresenter

- (instancetype)initWithView:(id<LoginView>)view {
    self = [super init];
    if (self) {
        self.view = view;
    }
    return self;
}

- (void)requestedLoginWithUsername:(NSString *)username
                           password:(NSString *)password {
    
}

- (void)loginSucceeded {
    
}

- (void)loginFailedWithError:(NSError *)error {
    
}

@end
