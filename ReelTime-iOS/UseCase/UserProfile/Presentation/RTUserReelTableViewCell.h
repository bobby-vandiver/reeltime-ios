#import <UIKit/UIKit.h>

#import "RTBrowseVideosView.h"

@class RTBrowseVideosPresenter;

@interface RTUserReelTableViewCell : UITableViewCell <UICollectionViewDelegate, RTBrowseVideosView>

- (void)configureWithVideosPresenter:(RTBrowseVideosPresenter *)videosPresenter;

@end
