#import <Foundation/Foundation.h>

@class RTVideoMessage;

@protocol RTBrowseVideosView <NSObject>

- (void)showVideoMessage:(RTVideoMessage *)message;

- (void)clearVideoMessages;

@end
