#import <Foundation/Foundation.h>

@class RTUserProfileWireframe;

@interface RTUserProfilePresenter : NSObject

- (instancetype)initWithWireframe:(RTUserProfileWireframe *)wireframe;

- (void)requestedAccountSettings;

@end
