#import <UIKit/UIKit.h>

@protocol RTUserReelFooterViewDelegate;

@interface RTUserReelFooterView : UITableViewHeaderFooterView

@property id<RTUserReelFooterViewDelegate> delegate;
@property (copy) NSNumber *reelId;

@property (weak, nonatomic) IBOutlet UIButton *followReelButton;
@property (weak, nonatomic) IBOutlet UIButton *listAudienceButton;

- (IBAction)pressedFollowReelButton;

- (IBAction)pressedListAudienceButton;

@end
