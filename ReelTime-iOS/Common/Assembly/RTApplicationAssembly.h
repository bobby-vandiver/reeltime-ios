#import <Typhoon/Typhoon.h>

#import "RTLoginAssembly.h"

#import "RTAppDelegate.h"
#import "RTApplicationWireframe.h"

#import "RTNewsfeedAssembly.h"
#import "RTBrowseAssembly.h"

@interface RTApplicationAssembly : TyphoonAssembly

@property (nonatomic, strong, readonly) RTLoginAssembly *loginAssembly;

// TODO: These should be removed along with their headers
@property (nonatomic, strong, readonly) RTNewsfeedAssembly *newsfeedAssembly;
@property (nonatomic, strong, readonly) RTBrowseAssembly *browseAssembly;

- (RTAppDelegate *)appDelegate;

- (RTApplicationWireframe *)applicationWireframe;

- (RTApplicationTabBarController *)applicationTabBarController;

@end
