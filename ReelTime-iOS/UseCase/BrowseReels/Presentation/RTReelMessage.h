#import <Foundation/Foundation.h>

@interface RTReelMessage : NSObject

@property (readonly, copy) NSString *text;
@property (readonly, copy) NSNumber *reelId;

+ (RTReelMessage *)reelMessageWithText:(NSString *)text
                             forReelId:(NSNumber *)reelId;

@end
