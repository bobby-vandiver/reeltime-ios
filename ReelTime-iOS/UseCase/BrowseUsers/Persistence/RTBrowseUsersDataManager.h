#import "RTPagedListDataManager.h"

@protocol RTBrowseUsersDataManagerDelegate;

@interface RTBrowseUsersDataManager : RTPagedListDataManager

- (instancetype)initWithDelegate:(id<RTBrowseUsersDataManagerDelegate>)delegate
                          client:(RTClient *)client;

@end
