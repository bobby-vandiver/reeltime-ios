#import "TyphoonAssembly.h"

@class RTApplicationAssembly;

@class RTRecordVideoViewController;
@class RTRecordVideoWireframe;

@interface RTRecordVideoAssembly : TyphoonAssembly

@property (nonatomic, strong, readonly) RTApplicationAssembly *applicationAssembly;

- (RTRecordVideoViewController *)recordVideoViewController;

- (RTRecordVideoWireframe *)recordVideoWireframe;

@end
