#import <Foundation/Foundation.h>

#import "RTMessageView.h"
#import "RTErrorMessageView.h"
#import "RTFieldValidationErrorView.h"

typedef NS_ENUM(NSInteger, RTConfirmAccountViewField) {
    RTConfirmAccountViewFieldConfirmationCode
};

@protocol RTConfirmAccountView <NSObject, RTMessageView, RTErrorMessageView, RTFieldValidationErrorView>

@end
