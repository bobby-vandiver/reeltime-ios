#import <Foundation/Foundation.h>

#import "RTMessageView.h"
#import "RTFieldValidationErrorView.h"

typedef NS_ENUM(NSInteger, RTChangeDisplayNameViewField) {
    RTChangeDisplayNameViewFieldDisplayName
};

@protocol RTChangeDisplayNameView <NSObject, RTMessageView, RTFieldValidationErrorView>

@end
