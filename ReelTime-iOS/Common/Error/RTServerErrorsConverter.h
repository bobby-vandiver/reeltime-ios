#import <Foundation/Foundation.h>

@protocol RTServerErrorMessageToErrorCodeMapping;
@class RTServerErrors;

@interface RTServerErrorsConverter : NSObject

- (instancetype)initWithMapping:(id<RTServerErrorMessageToErrorCodeMapping>)mapping;

- (NSError *)convertFirstErrorFromServerErrors:(RTServerErrors *)serverErrors;

- (NSArray *)convertServerErrors:(RTServerErrors *)serverErrors;


@end
