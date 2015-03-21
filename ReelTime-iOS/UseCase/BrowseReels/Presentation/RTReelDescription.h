#import <Foundation/Foundation.h>

@interface RTReelDescription : NSObject

@property (readonly, copy) NSString *text;
@property (readonly, copy) NSNumber *reelId;

+ (RTReelDescription *)reelDescriptionWithText:(NSString *)text
                                     forReelId:(NSNumber *)reelId;

@end
