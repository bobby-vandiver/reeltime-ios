#import "RTArrayDataSource.h"

@class RTActivity;

@interface RTNewsfeedTableViewDataSource : RTArrayDataSource

- (void)addActivity:(RTActivity *)activity;

@end
