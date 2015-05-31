#import "RTPagedListDataManager.h"

@protocol RTBrowseVideosDataManagerDelegate;
@class RTThumbnailSupport;

@interface RTBrowseVideosDataManager : RTPagedListDataManager

- (instancetype)initWithDelegate:(id<RTBrowseVideosDataManagerDelegate>)delegate
                thumbnailSupport:(RTThumbnailSupport *)thumbnailSupport
                          client:(RTAPIClient *)client;

@end
