#import <Typhoon/Typhoon.h>

#import "RTApplicationNavigationControllerFactory.h"

#import "RTLoginAssembly.h"

#import "RTAppDelegate.h"
#import "RTApplicationWindowHandle.h"
#import "RTApplicationWireframe.h"
#import "RTApplicationWireframeContainer.h"

#import "RTRecordVideoAssembly.h"
#import "RTNewsfeedAssembly.h"
#import "RTBrowseAllAssembly.h"

@interface RTApplicationAssembly : TyphoonAssembly <RTApplicationNavigationControllerFactory>

@property (nonatomic, strong, readonly) RTLoginAssembly *loginAssembly;

// TODO: These should be removed along with their headers
@property (nonatomic, strong, readonly) RTRecordVideoAssembly *recordVideoAssembly;
@property (nonatomic, strong, readonly) RTNewsfeedAssembly *newsfeedAssembly;
@property (nonatomic, strong, readonly) RTBrowseAllAssembly *browseAllAssembly;

- (RTAppDelegate *)appDelegate;

- (RTApplicationWindowHandle *)applicationWindowHandle;

- (RTApplicationWireframe *)applicationWireframe;

- (RTApplicationWireframeContainer *)applicationWireframeContainer;

- (RTApplicationTabBarController *)applicationTabBarController;

@end
