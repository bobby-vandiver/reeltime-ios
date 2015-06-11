#import <Foundation/Foundation.h>
#import "RTErrorMessageView.h"

@class RTClientDescription;

@protocol RTManageDevicesView <NSObject, RTErrorMessageView>

- (void)showClientDescription:(RTClientDescription *)description;

- (void)clearClientDescriptions;

- (void)clearClientDescriptionForClientId:(NSString *)clientId;

@end
