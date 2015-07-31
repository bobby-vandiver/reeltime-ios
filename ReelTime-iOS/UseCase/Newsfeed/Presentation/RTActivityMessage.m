#import "RTActivityMessage.h"

@interface RTActivityMessage ()

@property (copy, readwrite) NSString *text;
@property (readwrite) RTActivityType type;

@property (copy, readwrite) NSString *username;
@property (copy, readwrite) NSNumber *reelId;
@property (copy, readwrite) NSNumber *videoId;

@end

@implementation RTActivityMessage

+ (RTActivityMessage *)activityMessageWithText:(NSString *)text
                                          type:(RTActivityType)type
                                   forUsername:(NSString *)username
                                        reelId:(NSNumber *)reelId
                                       videoId:(NSNumber *)videoId {

    return [[RTActivityMessage alloc] initWithText:text
                                              type:type
                                       forUsername:username
                                            reelId:reelId
                                           videoId:videoId];
}

- (instancetype)initWithText:(NSString *)text
                           type:(RTActivityType)type
                    forUsername:(NSString *)username
                         reelId:(NSNumber *)reelId
                        videoId:(NSNumber *)videoId {
    self = [super init];
    if (self) {
        self.text = text;
        self.type = type;
        self.username = username;
        self.reelId = reelId;
        self.videoId = videoId;
    }
    return self;
}

@end
