#import <Foundation/Foundation.h>

@class RTMutableArrayDataSource;

@interface RTBrowseAllViewDataSourceFactory : NSObject

+ (RTMutableArrayDataSource *)usersDataSource;

+ (RTMutableArrayDataSource *)reelsDataSource;

+ (RTMutableArrayDataSource *)videosDataSource;

@end
