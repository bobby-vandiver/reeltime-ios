#import <Foundation/Foundation.h>

@class RTCaptureThumbnailWireframe;

@interface RTCaptureThumbnailPresenter : NSObject

- (instancetype)initWithWireframe:(RTCaptureThumbnailWireframe *)wireframe;

- (void)capturedThumbnail:(NSURL *)thumbnailURL;

@end
