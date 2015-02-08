#import <Foundation/Foundation.h>

@class RTActivity;

@protocol RTNewsfeedView <NSObject>

- (void)showActivity:(RTActivity *)activity;

@end
