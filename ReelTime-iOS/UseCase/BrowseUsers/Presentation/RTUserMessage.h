#import <Foundation/Foundation.h>

@interface RTUserMessage : NSObject

@property (readonly, copy) NSString *text;
@property (readonly, copy) NSString *username;

+ (RTUserMessage *)userMessageWithText:(NSString *)text
                           forUsername:(NSString *)username;

@end
