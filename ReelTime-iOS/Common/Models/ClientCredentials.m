//
//  ClientCredentials.m
//  ReelTime-iOS
//
//  Created by Bobby Vandiver on 12/27/14.
//  Copyright (c) 2014 ReelTime. All rights reserved.
//

#import "ClientCredentials.h"

@implementation ClientCredentials

- (instancetype)initWithClientId:(NSString *)clientId clientSecret:(NSString *)clientSecret {
    self = [super init];
    if (self) {
        self.clientId = clientId;
        self.clientSecret = clientSecret;
    }
    return self;
}

@end
