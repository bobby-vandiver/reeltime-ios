#import <Foundation/Foundation.h>

@protocol RTServerErrorMessageToErrorCodeMapping;
@class RTServerErrors;

@interface RTServerErrorsConverter : NSObject

- (instancetype)initWithMapping:(id<RTServerErrorMessageToErrorCodeMapping>)mapping;

- (NSArray *)convertServerErrors:(RTServerErrors *)serverErrors;


@end
