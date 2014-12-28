//
//  ClientCredentialsStore.m
//  ReelTime-iOS
//
//  Created by Bobby Vandiver on 12/27/14.
//  Copyright (c) 2014 ReelTime. All rights reserved.
//

#import "ClientCredentialsStore.h"

@interface ClientCredentialsStore ()

@property UICKeyChainStore *keyChainStore;

@end

@implementation ClientCredentialsStore

- (instancetype)initWithKeyChainStore:(UICKeyChainStore *)keyChainStore {
    self = [super init];
    if (self) {
        self.keyChainStore = keyChainStore;
    }
    return self;
}

- (ClientCredentials *)loadClientCredentials {
    return nil;
}

@end
