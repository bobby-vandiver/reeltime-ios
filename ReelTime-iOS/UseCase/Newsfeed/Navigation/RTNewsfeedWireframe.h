#import <Foundation/Foundation.h>

#import "RTUserWireframe.h"
#import "RTReelWireframe.h"
#import "RTVideoWireframe.h"

@class RTNewsfeedViewController;

@interface RTNewsfeedWireframe : NSObject <RTUserWireframe, RTReelWireframe, RTVideoWireframe>

- (instancetype)initWithViewController:(RTNewsfeedViewController *)viewController;

@end
