#import <Foundation/Foundation.h>

@class RTReelMessage;

@protocol RTBrowseReelsView <NSObject>

- (void)showReelMessage:(RTReelMessage *)message;

- (void)clearReelMessages;

@end
