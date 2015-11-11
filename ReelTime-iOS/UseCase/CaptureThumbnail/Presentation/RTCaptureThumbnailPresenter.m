#import "RTCaptureThumbnailPresenter.h"
#import "RTCaptureThumbnailWireframe.h"

@interface RTCaptureThumbnailPresenter ()

@property RTCaptureThumbnailWireframe *wireframe;

@end

@implementation RTCaptureThumbnailPresenter

- (instancetype)initWithWireframe:(RTCaptureThumbnailWireframe *)wireframe {
    self = [super init];
    if (self) {
        self.wireframe = wireframe;
    }
    return self;
}

- (void)capturedThumbnail:(NSURL *)thumbnailURL
                 forVideo:(NSURL *)videoURL {
    [self.wireframe presentUploadVideoInterfaceForVideo:videoURL thumbnail:thumbnailURL];
}

@end
