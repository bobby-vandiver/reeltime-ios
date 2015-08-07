#import "RTTestCommon.h"

#import "RTVideoDescription.h"

SpecBegin(RTVideoDescription)

describe(@"video description", ^{

    __block RTVideoDescription *videoDescription;
    
    beforeEach(^{
        videoDescription = [RTVideoDescription videoDescriptionWithTitle:anything()
                                                                 videoId:@(videoId)
                                                           thumbnailData:anything()];
    });
    
    describe(@"isEqual for invalid type", ^{
        it(@"nil", ^{
            BOOL equal = [videoDescription isEqual:nil];
            expect(equal).to.beFalsy();
        });
        
        it(@"non-video description", ^{
            BOOL equal = [videoDescription isEqual:[NSString string]];
            expect(equal).to.beFalsy();
        });
    });
    
    describe(@"isEqual and hash", ^{
        __block NSUInteger videoDescriptionHash;
        
        beforeEach(^{
            videoDescriptionHash = [videoDescription hash];
        });
        
        it(@"same instance", ^{
            BOOL equal = [videoDescription isEqual:videoDescription];
            expect(equal).to.beTruthy();
        });
        
        it(@"same videoId", ^{
            RTVideoDescription *other = [RTVideoDescription videoDescriptionWithTitle:anything()
                                                                              videoId:@(videoId)
                                                                        thumbnailData:anything()];
            
            BOOL equal = [videoDescription isEqual:other];
            expect(equal).to.beTruthy();
            
            NSUInteger otherHash = [other hash];
            expect(otherHash).to.equal(videoDescriptionHash);
        });
        
        it(@"different videoId", ^{
            RTVideoDescription *other = [RTVideoDescription videoDescriptionWithTitle:anything()
                                                                              videoId:@(videoId + 1)
                                                                        thumbnailData:anything()];
            
            BOOL equal = [videoDescription isEqual:other];
            expect(equal).to.beFalsy();
            
            NSUInteger otherHash = [other hash];
            expect(otherHash).toNot.equal(videoDescriptionHash);
        });
        
        it(@"nil videoId", ^{
            RTVideoDescription *other = [RTVideoDescription videoDescriptionWithTitle:anything()
                                                                              videoId:nil
                                                                        thumbnailData:anything()];
            
            BOOL equal = [videoDescription isEqual:other];
            expect(equal).to.beFalsy();
            
            NSUInteger otherHash = [other hash];
            expect(otherHash).toNot.equal(videoDescriptionHash);
        });
        
        it(@"both nil videoId", ^{
            RTVideoDescription *left = [RTVideoDescription videoDescriptionWithTitle:anything()
                                                                             videoId:nil
                                                                       thumbnailData:anything()];
            
            RTVideoDescription *right = [RTVideoDescription videoDescriptionWithTitle:anything()
                                                                              videoId:nil
                                                                        thumbnailData:anything()];
            
            BOOL equal = [left isEqual:right];
            expect(equal).to.beFalsy();
        });
    });
});

SpecEnd
