#import <Foundation/Foundation.h>

@class RTUserDescription;

@protocol RTUserDescriptionView <NSObject>

- (void)showUserDescription:(RTUserDescription *)description;

@end
