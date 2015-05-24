#import <Foundation/Foundation.h>

#import "RTMessageView.h"
#import "RTErrorMessageView.h"
#import "RTFieldValidationErrorView.h"

typedef NS_ENUM(NSInteger, RTChangePasswordViewField) {
    RTChangePasswordViewFieldPassword,
    RTChangePasswordViewFieldConfirmationPassword
};

@protocol RTChangePasswordView <NSObject, RTMessageView, RTErrorMessageView, RTFieldValidationErrorView>

@end
