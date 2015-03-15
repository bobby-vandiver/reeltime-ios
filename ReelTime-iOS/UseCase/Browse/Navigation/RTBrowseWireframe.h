#import <Foundation/Foundation.h>

#import "RTUserWireframe.h"
#import "RTReelWireframe.h"
#import "RTVideoWireframe.h"

@class RTBrowseViewController;

@interface RTBrowseWireframe : NSObject <RTUserWireframe, RTReelWireframe, RTVideoWireframe>

- (instancetype)initWithViewController:(RTBrowseViewController *)viewController;

@end
