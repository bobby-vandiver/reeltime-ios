#import <Foundation/Foundation.h>

@class RTRecordVideoWireframe;

@interface RTRecordVideoPresenter : NSObject

- (instancetype)initWithWireframe:(RTRecordVideoWireframe *)wireframe;

- (void)recordedVideo:(NSURL *)videoURL;

@end
