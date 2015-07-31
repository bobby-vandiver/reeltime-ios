#import <Foundation/Foundation.h>
#import "RTActivityType.h"

@class RTStringWithEmbeddedLinks;

@interface RTActivityMessage : NSObject

@property (copy, readonly) NSString *text;
@property (readonly) RTActivityType type;

@property (copy, readonly) NSString *username;
@property (copy, readonly) NSNumber *reelId;
@property (copy, readonly) NSNumber *videoId;

+ (RTActivityMessage *)activityMessageWithText:(NSString *)text
                                          type:(RTActivityType)type
                                   forUsername:(NSString *)username
                                        reelId:(NSNumber *)reelId
                                       videoId:(NSNumber *)videoId;

@end
