#import <Foundation/Foundation.h>

@class RTVideoDescription;

@protocol RTBrowseVideosView <NSObject>

- (void)showVideoDescription:(RTVideoDescription *)description;

- (void)clearVideoDescriptions;

@end
