#import <Foundation/Foundation.h>

@class RTMutableArrayDataSource;

@interface RTBrowseViewDataSourceFactory : NSObject

+ (RTMutableArrayDataSource *)usersDataSource;

+ (RTMutableArrayDataSource *)reelsDataSource;

+ (RTMutableArrayDataSource *)videosDataSource;

@end
