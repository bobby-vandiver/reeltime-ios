#import "NSURL+RTURL.h"
#import "RTRegexPattern.h"

@implementation NSURL (RTURL)

- (BOOL)isUserURL {
    NSString *pattern = [NSString stringWithFormat:@"^reeltime://users/%@$", USERNAME_PATTERN];
    return [self isValidURLForPattern:pattern];
}

- (NSString *)username {
    NSString *username;
    
    if ([self isUserURL]) {
        username = self.lastPathComponent;
    }
    
    return username;
}

- (BOOL)isReelURL {
    NSString *pattern = @"^reeltime://reels/\\d+$";
    return [self isValidURLForPattern:pattern];
}

- (NSNumber *)reelId {
    NSNumber *reelId;

    if ([self isReelURL]) {
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        reelId = [formatter numberFromString:self.lastPathComponent];
    }
    
    return reelId;
}

- (BOOL)isVideoURL {
    NSString *pattern = @"^reeltime://videos/\\d+$";
    return [self isValidURLForPattern:pattern];
}

- (NSNumber *)videoId {
    NSNumber *videoId;
    
    if ([self isVideoURL]) {
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        videoId = [formatter numberFromString:self.lastPathComponent];
    }
    
    return videoId;
}

- (BOOL)isValidURLForPattern:(NSString *)pattern {
    NSPredicate *regexPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    return [regexPredicate evaluateWithObject:self.absoluteString];
}

@end