//
//  LoginInteractor.m
//  ReelTime-iOS
//
//  Created by Bobby Vandiver on 12/28/14.
//  Copyright (c) 2014 ReelTime. All rights reserved.
//

#import "LoginInteractor.h"

@interface LoginInteractor ()

@property LoginPresenter *presenter;
@property ClientCredentialsStore *clientCredentialsStore;

@end

@implementation LoginInteractor

- (instancetype)initWithPresenter:(LoginPresenter *)presenter
           clientCredentialsStore:(ClientCredentialsStore *)clientCredentialsStore {
    self = [super init];
    if (self) {
        self.presenter = presenter;
        self.clientCredentialsStore = clientCredentialsStore;
    }
    return self;
}

- (void)loginWithUsername:(NSString *)username
                 password:(NSString *)password {
    ClientCredentials *clientCredentials = [self.clientCredentialsStore loadClientCredentials];

    if (!clientCredentials) {
        [self.presenter loginDidFailWithUnknownClient];
        return;
    }

    [self.presenter loginDidSucceed];
}

@end
