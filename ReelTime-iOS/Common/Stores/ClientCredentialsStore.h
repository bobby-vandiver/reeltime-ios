//
//  ClientCredentialsStore.h
//  ReelTime-iOS
//
//  Created by Bobby Vandiver on 12/27/14.
//  Copyright (c) 2014 ReelTime. All rights reserved.
//

#import <UICKeyChainStore/UICKeyChainStore.h>
#import "ClientCredentials.h"

@interface ClientCredentialsStore : NSObject

- (instancetype)initWithKeyChainStore:(UICKeyChainStore *)keyChainStore;

- (ClientCredentials *)loadClientCredentials;

@end
