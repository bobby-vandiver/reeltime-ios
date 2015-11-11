#import <Typhoon/Typhoon.h>
#import "RTCaptureThumbnailViewControllerFactory.h"

@class RTUploadVideoAssembly;
@class RTApplicationAssembly;

@class RTCaptureThumbnailWireframe;
@class RTCaptureThumbnailPresenter;

@interface RTCaptureThumbnailAssembly : TyphoonAssembly <RTCaptureThumbnailViewControllerFactory>

@property (nonatomic, strong, readonly) RTUploadVideoAssembly *uploadVideoAssembly;
@property (nonatomic, strong, readonly) RTApplicationAssembly *applicationAssembly;

- (RTCaptureThumbnailWireframe *)captureThumbnailWireframe;

- (RTCaptureThumbnailPresenter *)captureThumbnailPresenterForVideo:(NSURL *)videoURL;

@end
