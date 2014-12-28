//
//  LoginView.h
//  ReelTime-iOS
//
//  Created by Bobby Vandiver on 12/28/14.
//  Copyright (c) 2014 ReelTime. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LoginView <NSObject>

- (void)showErrorMessage:(NSString *)message;

@end
