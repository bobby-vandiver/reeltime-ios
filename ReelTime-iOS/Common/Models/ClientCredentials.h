//
//  ClientCredentials.h
//  ReelTime-iOS
//
//  Created by Bobby Vandiver on 12/27/14.
//  Copyright (c) 2014 ReelTime. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClientCredentials : NSObject

@property (nonatomic, copy) NSString *clientId;
@property (nonatomic, copy) NSString *clientSecret;

@end
