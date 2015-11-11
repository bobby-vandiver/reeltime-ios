#import "RTRecordVideoPresenter.h"
#import "RTRecordVideoWireframe.h"

@interface RTRecordVideoPresenter ()

@property RTRecordVideoWireframe *wireframe;

@end

@implementation RTRecordVideoPresenter

- (instancetype)initWithWireframe:(RTRecordVideoWireframe *)wireframe {
    self = [super init];
    if (self) {
        self.wireframe = wireframe;
    }
    return self;
}

- (void)recordedVideo:(NSURL *)videoURL {
    [self.wireframe presentCaptureThumbnailInterfaceForVideo:videoURL];
}

@end
