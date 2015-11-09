#import <Typhoon/Typhoon.h>
#import "RTUploadVideoViewControllerFactory.h"

@class RTClientAssembly;
@class RTRecordVideoAssembly;
@class RTApplicationAssembly;

@class RTUploadVideoWireframe;
@class RTUploadVideoPresenter;
@class RTUploadVideoInteractor;
@class RTUploadVideoValidator;
@class RTUploadVideoDataManager;

@interface RTUploadVideoAssembly : TyphoonAssembly <RTUploadVideoViewControllerFactory>

@property (nonatomic, strong, readonly) RTClientAssembly *clientAssembly;
@property (nonatomic, strong, readonly) RTRecordVideoAssembly *recordVideoAssembly;
@property (nonatomic, strong, readonly) RTApplicationAssembly *applicationAssembly;

- (RTUploadVideoWireframe *)uploadVideoWireframe;

- (RTUploadVideoPresenter *)uploadVideoPresenterForVideo:(NSURL *)videoUrl thumbnail:(NSURL *)thumbnailUrl;

- (RTUploadVideoInteractor *)uploadVideoInteractorForVideo:(NSURL *)videoUrl thumbnail:(NSURL *)thumbnailUrl;

- (RTUploadVideoValidator *)uploadVideoValidator;

- (RTUploadVideoDataManager *)uploadVideoDataManager;

@end
