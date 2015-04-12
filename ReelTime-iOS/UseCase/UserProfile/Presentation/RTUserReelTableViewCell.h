#import <UIKit/UIKit.h>

#import "RTBrowseVideosView.h"

@class RTBrowseVideosPresenter;

@interface RTUserReelTableViewCell : UITableViewCell <UITableViewDelegate, RTBrowseVideosView>

- (void)configureWithVideosPresenter:(RTBrowseVideosPresenter *)videosPresenter;

@end
