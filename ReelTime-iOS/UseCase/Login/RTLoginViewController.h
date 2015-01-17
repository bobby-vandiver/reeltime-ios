#import <UIKit/UIKit.h>
#import "RTLoginView.h"

@class RTLoginPresenter;

@interface RTLoginViewController : UIViewController <RTLoginView>

+ (NSString *)storyboardIdentifier;

- (instancetype)initWithPresenter:(RTLoginPresenter *)presenter;

@end
