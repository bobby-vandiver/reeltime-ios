#import <UIKit/UIKit.h>

#import "RTStoryboardViewController.h"

@interface RTPlayVideoViewController : UIViewController <RTStoryboardViewController>

+ (instancetype)viewControllerForVideoId:(NSNumber *)videoId;

@end
