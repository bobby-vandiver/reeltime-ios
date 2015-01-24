#import <Foundation/Foundation.h>

@class RTServerErrors;

@interface RTServerErrorsConverter : NSObject

- (NSArray *)convertServerErrors:(RTServerErrors *)serverErrors
                     withMapping:(NSDictionary *)mapping
                       converter:(NSError *(^)(NSInteger code))converter;

@end
