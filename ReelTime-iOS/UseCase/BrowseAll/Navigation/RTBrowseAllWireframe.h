#import <Foundation/Foundation.h>

#import "RTUserWireframe.h"
#import "RTReelWireframe.h"
#import "RTVideoWireframe.h"

@class RTBrowseAllViewController;

@interface RTBrowseAllWireframe : NSObject <RTUserWireframe, RTReelWireframe, RTVideoWireframe>

- (instancetype)initWithViewController:(RTBrowseAllViewController *)viewController;

@end
