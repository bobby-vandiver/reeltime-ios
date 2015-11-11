#import <Foundation/Foundation.h>

@class RTRecordVideoCamera;

@protocol RTRecordVideoCameraDelegate <NSObject>

- (void)recordingStarted;

- (void)recordingStopped:(NSURL *)videoURL;

@end
