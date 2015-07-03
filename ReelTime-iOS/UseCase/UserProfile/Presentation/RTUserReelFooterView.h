#import <UIKit/UIKit.h>

@interface RTUserReelFooterView : UITableViewHeaderFooterView

@property (weak, nonatomic) IBOutlet UIButton *followReelButton;
@property (weak, nonatomic) IBOutlet UIButton *listAudienceButton;

- (IBAction)pressedFollowReelButton;

- (IBAction)pressedListAudienceButton;

@end
