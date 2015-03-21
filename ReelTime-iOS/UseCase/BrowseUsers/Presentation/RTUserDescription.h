#import <Foundation/Foundation.h>

@interface RTUserDescription : NSObject

@property (readonly, copy) NSString *text;
@property (readonly, copy) NSString *username;

+ (RTUserDescription *)userDescriptionWithText:(NSString *)text
                                   forUsername:(NSString *)username;

@end
