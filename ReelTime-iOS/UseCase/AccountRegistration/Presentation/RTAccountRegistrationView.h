#import <Foundation/Foundation.h>

#import "RTErrorMessageView.h"
#import "RTFieldValidationErrorView.h"

typedef NS_ENUM(NSInteger, RTAccountRegistrationViewField) {
    RTAccountRegistrationViewFieldUsername,
    RTAccountRegistrationViewFieldPassword,
    RTAccountRegistrationViewFieldConfirmationPassword,
    RTAccountRegistrationViewFieldEmail,
    RTAccountRegistrationViewFieldDisplayName,
    RTAccountRegistrationViewFieldClientName
};

@protocol RTAccountRegistrationView <NSObject, RTErrorMessageView, RTFieldValidationErrorView>

@end
