//
//  ReelTimeClient.m
//  ReelTime-iOS
//
//  Created by Bobby Vandiver on 12/28/14.
//  Copyright (c) 2014 ReelTime. All rights reserved.
//

#import "ReelTimeClient.h"
#import "ReelTimeClientErrors.h"

@interface ReelTimeClient ()

@property RKObjectManager *objectManager;

@end

@implementation ReelTimeClient

- (instancetype)initWithRestKitObjectManager:(RKObjectManager *)objectManager {
    self = [super init];
    if (self) {
        self.objectManager = objectManager;
    }
    return self;
}

- (void)tokenWithClientCredentials:(ClientCredentials *)clientCredentials
                   userCredentials:(UserCredentials *)userCredentials
                           success:(TokenSuccessHandler)successHandler
                           failure:(TokenFailureHandler)failureHandler {
}

@end
