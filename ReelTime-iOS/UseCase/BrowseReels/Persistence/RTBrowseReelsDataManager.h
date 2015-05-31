#import "RTPagedListDataManager.h"

@protocol RTBrowseReelsDataManagerDelegate;

@interface RTBrowseReelsDataManager : RTPagedListDataManager

- (instancetype)initWithDelegate:(id<RTBrowseReelsDataManagerDelegate>)delegate
                          client:(RTAPIClient *)client;

@end
