#import <Foundation/Foundation.h>

@class RTReelDescription;

@protocol RTBrowseReelsView <NSObject>

- (void)showReelDescription:(RTReelDescription *)description;

- (void)clearReelDescriptions;

@end
