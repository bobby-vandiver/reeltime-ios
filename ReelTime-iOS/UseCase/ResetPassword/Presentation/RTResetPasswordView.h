#import <Foundation/Foundation.h>

#import "RTMessageView.h"
#import "RTErrorMessageView.h"
#import "RTFieldValidationErrorView.h"

typedef NS_ENUM(NSInteger, RTResetPasswordViewField) {
    RTResetPasswordViewFieldResetCode,
    RTResetPasswordViewFieldUsername,
    RTResetPasswordViewFieldPassword,
    RTResetPasswordViewFieldConfirmationPassword,
    RTResetPasswordViewFieldClientName
};

@protocol RTResetPasswordView <NSObject, RTMessageView, RTErrorMessageView, RTFieldValidationErrorView>

@end
