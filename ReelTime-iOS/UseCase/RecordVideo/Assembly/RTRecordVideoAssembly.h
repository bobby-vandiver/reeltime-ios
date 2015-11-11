#import "TyphoonAssembly.h"

@class RTCaptureThumbnailAssembly;
@class RTApplicationAssembly;

@class RTRecordVideoViewController;
@class RTRecordVideoWireframe;
@class RTRecordVideoPresenter;

@interface RTRecordVideoAssembly : TyphoonAssembly

@property (nonatomic, strong, readonly) RTCaptureThumbnailAssembly *captureThumbnailAssembly;
@property (nonatomic, strong, readonly) RTApplicationAssembly *applicationAssembly;

- (RTRecordVideoViewController *)recordVideoViewController;

- (RTRecordVideoWireframe *)recordVideoWireframe;

- (RTRecordVideoPresenter *)recordVideoPresenter;

@end
