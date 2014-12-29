//
//  ReelTimeClient.h
//  ReelTime-iOS
//
//  Created by Bobby Vandiver on 12/28/14.
//  Copyright (c) 2014 ReelTime. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

#import "ReelTimeClientErrors.h"

#import "ClientCredentials.h"
#import "UserCredentials.h"
#import "OAuth2Token.h"

@interface ReelTimeClient : NSObject

typedef void (^TokenSuccessHandler)(OAuth2Token *token);
typedef void (^TokenFailureHandler)(NSError *error);

- (instancetype)initWithRestKitObjectManager:(RKObjectManager *)objectManager;

- (void)tokenWithClientCredentials:(ClientCredentials *)clientCredentials
                   userCredentials:(UserCredentials *)userCredentials
                           success:(TokenSuccessHandler)successHandler
                           failure:(TokenFailureHandler)failureHandler;

@end
