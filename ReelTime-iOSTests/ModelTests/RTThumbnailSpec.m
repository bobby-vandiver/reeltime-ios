#import "RTTestCommon.h"

#import "RTThumbnail.h"

SpecBegin(RTThumbnail)

describe(@"thumbnail", ^{
    
    __block RTThumbnail *thumbnail;
    __block RTThumbnail *differentThumbnail;
    
    beforeEach(^{
        unsigned char bytes[] = { 0x01, 0x02, 0x03, 0x04, 0x05 };
        
        NSData *thumbnailData = [NSData dataWithBytes:bytes length:sizeof(bytes)];
        thumbnail = [[RTThumbnail alloc] initWithData:thumbnailData];
        
        unsigned char differentBytes[] = { 0x10, 0x11, 0x12, 0x13 };
        
        NSData *differentThumbnailData = [NSData dataWithBytes:differentBytes length:sizeof(differentBytes)];
        differentThumbnail = [[RTThumbnail alloc] initWithData:differentThumbnailData];
    });
    
    describe(@"copy", ^{
        it(@"shallow copy of data per NSData copy semantics", ^{
            RTThumbnail *copy = [thumbnail copy];
            expect(copy).toNot.beIdenticalTo(thumbnail);
            expect(copy.data).to.equal(thumbnail.data);
        });
    });
    
    describe(@"isEqual for thumbnail with non-thumbnail", ^{
        it(@"nil", ^{
            BOOL equal = [thumbnail isEqual:nil];
            expect(equal).to.beFalsy();
        });
        
        it(@"non-thumbnail", ^{
            BOOL equal = [thumbnail isEqual:[NSString string]];
            expect(equal).to.beFalsy();
        });
    });
    
    describe(@"isEqual and hash for thumbanils", ^{
        __block NSUInteger thumbnailHash;
        
        beforeEach(^{
            thumbnailHash = [thumbnail hash];
        });
        
        describe(@"thumbnails are equal", ^{
            it(@"same instance", ^{
                BOOL equal = [thumbnail isEqual:thumbnail];
                expect(equal).to.beTruthy();
            });
            
            it(@"same data", ^{
                NSData *copyData = [thumbnail.data copy];
                RTThumbnail *other = [[RTThumbnail alloc] initWithData:copyData];
                
                BOOL equal = [thumbnail isEqual:other];
                expect(equal).to.beTruthy();
                
                NSUInteger otherHash = [other hash];
                expect(otherHash).to.equal(thumbnailHash);
            });
        });
        
        describe(@"thumbnails are not equal", ^{
            it(@"different data", ^{
                BOOL equal = [thumbnail isEqual:differentThumbnail];
                expect(equal).to.beFalsy();
                
                NSUInteger differentHash = [differentThumbnail hash];
                expect(differentHash).toNot.equal(thumbnailHash);
            });
        });
    });
});

SpecEnd