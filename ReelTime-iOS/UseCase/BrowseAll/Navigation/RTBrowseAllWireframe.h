#import <Foundation/Foundation.h>

#import "RTUserWireframe.h"
#import "RTReelWireframe.h"
#import "RTVideoWireframe.h"

@class RTUserProfileAssembly;
@class RTBrowseAllViewController;

@interface RTBrowseAllWireframe : NSObject <RTUserWireframe, RTReelWireframe, RTVideoWireframe>

// TODO: Depend on factory protocol instead of assembly
@property RTUserProfileAssembly *userProfileAssembly;

- (instancetype)initWithViewController:(RTBrowseAllViewController *)viewController;

@end
