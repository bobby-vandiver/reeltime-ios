#import <Typhoon/Typhoon.h>

#import "RTLoginAssembly.h"

#import "RTAppDelegate.h"
#import "RTApplicationWireframe.h"

#import "RTNewsfeedAssembly.h"
#import "RTBrowseAllAssembly.h"

@interface RTApplicationAssembly : TyphoonAssembly

@property (nonatomic, strong, readonly) RTLoginAssembly *loginAssembly;

// TODO: These should be removed along with their headers
@property (nonatomic, strong, readonly) RTNewsfeedAssembly *newsfeedAssembly;
@property (nonatomic, strong, readonly) RTBrowseAllAssembly *browseAllAssembly;

- (RTAppDelegate *)appDelegate;

- (RTApplicationWireframe *)applicationWireframe;

- (RTApplicationTabBarController *)applicationTabBarController;

@end
