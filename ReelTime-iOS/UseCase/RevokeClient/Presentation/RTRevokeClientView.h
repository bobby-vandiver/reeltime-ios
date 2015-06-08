#import <Foundation/Foundation.h>

#import "RTMessageView.h"
#import "RTErrorMessageView.h"

@protocol RTRevokeClientView <NSObject, RTMessageView, RTErrorMessageView>

@end
