//
//  UserCredentials.h
//  ReelTime-iOS
//
//  Created by Bobby Vandiver on 12/28/14.
//  Copyright (c) 2014 ReelTime. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserCredentials : NSObject

@property (nonatomic, readonly, copy) NSString *username;
@property (nonatomic, readonly, copy) NSString *password;

- (instancetype)initWithUsername:(NSString *)username
                        password:(NSString *)password;

@end
