#import <Foundation/Foundation.h>

@interface RTVideoMessage : NSObject

@property (readonly, copy) NSString *text;
@property (readonly, copy) NSNumber *videoId;

+ (RTVideoMessage *)videoMessageWithText:(NSString *)text
                                 videoId:(NSNumber *)videoId;

@end
