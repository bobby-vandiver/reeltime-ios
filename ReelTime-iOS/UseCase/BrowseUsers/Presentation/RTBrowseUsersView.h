#import <Foundation/Foundation.h>

@class RTUserDescription;

@protocol RTBrowseUsersView <NSObject>

- (void)showUserDescription:(RTUserDescription *)description;

- (void)clearUserDescriptions;

@end
