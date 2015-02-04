#import "EXPMatchers+beVideo.h"
#import "EXPMatchers+ErrorMessages.h"

#import "RTVideo.h"

EXPMatcherImplementationBegin(beVideo, (NSNumber *expectedVideoId, NSString *expectedTitle)) {
    
    BOOL actualIsNil = (actual == nil);
    BOOL actualIsVideo = [actual isKindOfClass:[RTVideo class]];
    
    BOOL expectedVideoIdIsNil = (expectedVideoId == nil);
    BOOL expectedTitleIsNil = (expectedTitle == nil);
    
    __block RTVideo *actualVideo;
    
    __block NSNumber *actualVideoId;
    __block NSString *actualTitle;
    
    __block BOOL sameVideoId;
    __block BOOL sameTitle;
    
    prerequisite(^BOOL {
        return !(actualIsNil || expectedVideoIdIsNil || expectedTitleIsNil);
    });
    
    match(^BOOL {
        if (!actualIsVideo) {
            return NO;
        }
        actualVideo = (RTVideo *)actual;
        
        actualVideoId = actualVideo.videoId;
        actualTitle = actualVideo.title;
        
        sameVideoId = [actualVideoId isEqualToNumber:expectedVideoId];
        sameTitle = [actualTitle isEqualToString:expectedTitle];
        
        return (sameVideoId && sameTitle);
    });
    
    failureMessageForTo(^NSString * {
        if (actualIsNil) {
            return actualValueIsNil();
        }
        if (expectedVideoIdIsNil) {
            return expectedValueIsNil(@"video id");
        }
        if (expectedTitleIsNil) {
            return expectedValueIsNil(@"title");
        }
        if (!actualIsVideo) {
            return actualIsNotClass([actual class], [RTVideo class]);
        }
        if (!sameVideoId) {
            return actualIsNotExpected(@"video id", actualVideoId, expectedVideoId);
        }
        return actualIsNotExpected(@"title", actualTitle, expectedTitle);
    });
    
    failureMessageForNotTo(^NSString * {
        if (actualIsNil) {
            return actualValueIsNil();
        }
        if (expectedVideoIdIsNil) {
            return expectedValueIsNil(@"video id");
        }
        if (expectedTitleIsNil) {
            return expectedValueIsNil(@"title");
        }
        if (actualIsVideo) {
            return actualIsClass([actual class], [RTVideo class]);
        }
        if (sameVideoId) {
            return actualIsExpected(@"video id", actualVideoId, expectedVideoId);
        }
        return actualIsExpected(@"title", actualTitle, expectedTitle);
    });
}
EXPMatcherImplementationEnd