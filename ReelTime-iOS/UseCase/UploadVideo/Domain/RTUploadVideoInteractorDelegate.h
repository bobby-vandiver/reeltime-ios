#import <Foundation/Foundation.h>

@class RTVideo;

@protocol RTUploadVideoInteractorDelegate <NSObject>

- (void)uploadSucceededForVideo:(RTVideo *)video;

- (void)uploadFailedWithErrors:(NSArray *)errors;

@end
