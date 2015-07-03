#import "RTUserReelFooterView.h"
#import "RTUserReelFooterViewDelegate.h"

@implementation RTUserReelFooterView

- (IBAction)pressedFollowReelButton {
    [self.delegate footerView:self didPressFollowReelButton:self.followReelButton forReelId:self.reelId];
}

- (IBAction)pressedListAudienceButton {
    [self.delegate footerView:self didPressListAudienceButton:self.listAudienceButton forReelId:self.reelId];
}

@end
