#import <Foundation/Foundation.h>

@class RTUserDescription;

@protocol RTUserSummaryView <NSObject>

- (void)showUserDescription:(RTUserDescription *)description;

- (void)showUserNotFoundMessage:(NSString *)message;

@end
