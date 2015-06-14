#import <Foundation/Foundation.h>

#import "RTMessageView.h"
#import "RTErrorMessageView.h"

@protocol RTConfirmAccountView <NSObject, RTMessageView, RTErrorMessageView>

@end
