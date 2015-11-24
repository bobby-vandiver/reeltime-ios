#import <UIKit/UIKit.h>

#import "RTRemoveAccountView.h"
#import "RTStoryboardViewController.h"

@class RTRemoveAccountPresenter;

@interface RTRemoveAccountViewController : UIViewController <RTRemoveAccountView, RTStoryboardViewController>

+ (instancetype)viewControllerWithPresenter:(RTRemoveAccountPresenter *)presenter;

- (IBAction)pressedRemoveButton;

@end
