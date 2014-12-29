//
//  ReelTimeClientAssembly.h
//  ReelTime-iOS
//
//  Created by Bobby Vandiver on 12/28/14.
//  Copyright (c) 2014 ReelTime. All rights reserved.
//

#import <Typhoon/Typhoon.h>

@class ReelTimeClient;
@class RKObjectManager;

@interface ReelTimeClientAssembly : TyphoonAssembly

- (ReelTimeClient *)reelTimeClient;

@end
