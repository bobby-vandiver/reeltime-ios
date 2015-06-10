#import <Foundation/Foundation.h>

@class RTClientDescription;

@protocol RTManageDevicesView <NSObject>

- (void)showClientDescription:(RTClientDescription *)description;

- (void)clearClientDescriptions;

- (void)clearClientDescriptionForClientId:(NSString *)clientId;

@end
