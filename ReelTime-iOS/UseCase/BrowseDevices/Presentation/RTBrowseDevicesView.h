#import <Foundation/Foundation.h>

@class RTClientDescription;

@protocol RTBrowseDevicesView <NSObject>

- (void)showClientDescription:(RTClientDescription *)description;

- (void)clearClientDescriptions;

@end
