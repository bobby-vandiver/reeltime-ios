#import <Foundation/Foundation.h>

@class RTUserMessage;

@protocol RTBrowseUsersView <NSObject>

- (void)showUserMessage:(RTUserMessage *)message;

- (void)clearMessages;

@end
