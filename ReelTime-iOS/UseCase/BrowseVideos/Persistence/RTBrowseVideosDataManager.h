#import "RTPagedListDataManager.h"

@protocol RTBrowseVideosDataManagerDelegate;

@interface RTBrowseVideosDataManager : RTPagedListDataManager

- (instancetype)initWithDelegate:(id<RTBrowseVideosDataManagerDelegate>)delegate
                          client:(RTClient *)client;

@end
