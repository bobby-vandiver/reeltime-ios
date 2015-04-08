#import <Foundation/Foundation.h>

@protocol RTUserSummaryDataManagerDelegate;

@class RTClient;
@class RTUser;

@interface RTUserSummaryDataManager : NSObject

- (instancetype)initWithDelegate:(id<RTUserSummaryDataManagerDelegate>)delegate
                          client:(RTClient *)client;

- (void)fetchUserForUsername:(NSString *)username
                    callback:(void (^)(RTUser *user))callback;

@end
