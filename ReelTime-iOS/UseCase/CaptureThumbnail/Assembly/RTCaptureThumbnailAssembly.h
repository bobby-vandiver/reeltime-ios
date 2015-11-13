#import <Typhoon/Typhoon.h>
#import "RTCaptureThumbnailViewControllerFactory.h"

@class RTUploadVideoAssembly;
@class RTPlayVideoAssembly;

@class RTCommonComponentsAssembly;
@class RTApplicationAssembly;

@class RTCaptureThumbnailWireframe;
@class RTCaptureThumbnailPresenter;

@interface RTCaptureThumbnailAssembly : TyphoonAssembly <RTCaptureThumbnailViewControllerFactory>

@property (nonatomic, strong, readonly) RTUploadVideoAssembly *uploadVideoAssembly;
@property (nonatomic, strong, readonly) RTPlayVideoAssembly *playVideoAssembly;

@property (nonatomic, strong, readonly) RTCommonComponentsAssembly *commonComponentsAssembly;
@property (nonatomic, strong, readonly) RTApplicationAssembly *applicationAssembly;

- (RTCaptureThumbnailWireframe *)captureThumbnailWireframe;

- (RTCaptureThumbnailPresenter *)captureThumbnailPresenterForVideo:(NSURL *)videoURL;

@end
