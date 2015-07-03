#import <UIKit/UIKit.h>

@class RTUserReelFooterView;

@protocol RTUserReelFooterViewDelegate <NSObject>

- (void)footerView:(RTUserReelFooterView *)footerView didPressFollowReelButton:(UIButton *)button forReelId:(NSNumber *)reelId;

- (void)footerView:(RTUserReelFooterView *)footerView didPressListAudienceButton:(UIButton *)button forReelId:(NSNumber *)reelId;

@end
