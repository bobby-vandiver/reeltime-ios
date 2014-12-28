//
//  LoginInteractor.h
//  ReelTime-iOS
//
//  Created by Bobby Vandiver on 12/28/14.
//  Copyright (c) 2014 ReelTime. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LoginPresenter.h"
#import "ClientCredentialsStore.h"

@interface LoginInteractor : NSObject

- (instancetype)initWithPresenter:(LoginPresenter *)presenter
           clientCredentialsStore:(ClientCredentialsStore *)clientCredentialsStore;

- (void)loginWithUsername:(NSString *)username
                 password:(NSString *)password;

@end
