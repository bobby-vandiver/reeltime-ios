#import <UIKit/UIKit.h>

#import "RTBrowseVideosView.h"

@class RTBrowseVideosPresenter;

@interface RTUserReelCell : UITableViewCell <UICollectionViewDelegate, RTBrowseVideosView>

- (void)configureWithVideosPresenter:(RTBrowseVideosPresenter *)videosPresenter;

@end
