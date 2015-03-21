#import <Foundation/Foundation.h>

@interface RTVideoDescription : NSObject

@property (readonly, copy) NSString *text;
@property (readonly, copy) NSNumber *videoId;

+ (RTVideoDescription *)videoDescriptionWithText:(NSString *)text
                                         videoId:(NSNumber *)videoId;

@end
