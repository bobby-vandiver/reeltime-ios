#import <Foundation/Foundation.h>

@protocol RTFieldValidationErrorView <NSObject>

- (void)showValidationErrorMessage:(NSString *)message
                          forField:(NSInteger)field;

@end
