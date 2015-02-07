#import <Foundation/Foundation.h>

@interface RTConditionalMessage : NSObject

@property (readonly) BOOL condition;
@property (readonly, copy) NSString *message;

+ (RTConditionalMessage *)trueWithMessage:(NSString *)message;

+ (RTConditionalMessage *)falseWithMessage:(NSString *)message;

@end
