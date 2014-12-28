//
//  UserCredentials.m
//  ReelTime-iOS
//
//  Created by Bobby Vandiver on 12/28/14.
//  Copyright (c) 2014 ReelTime. All rights reserved.
//

#import "UserCredentials.h"

@interface UserCredentials ()

@property (nonatomic, readwrite, copy) NSString *username;
@property (nonatomic, readwrite, copy) NSString *password;

@end

@implementation UserCredentials

- (instancetype)initWithUsername:(NSString *)username
                        password:(NSString *)password {
    self = [super init];
    if (self) {
        self.username = username;
        self.password = password;
    }
    return self;
}

@end
