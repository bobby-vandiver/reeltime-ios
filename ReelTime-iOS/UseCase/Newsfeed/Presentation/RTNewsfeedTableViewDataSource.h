#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class RTActivity;

@interface RTNewsfeedTableViewDataSource : NSObject <UITableViewDataSource>

- (void)addActivity:(RTActivity *)activity;

@end
