#import <Foundation/Foundation.h>

@class RTRecordVideoCamera;

@protocol RTRecordVideoCameraDelegate <NSObject>

- (void)recordingStarted;

- (void)recordingStopped;

@end
