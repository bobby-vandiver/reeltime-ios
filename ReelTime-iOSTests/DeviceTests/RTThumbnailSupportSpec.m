#import "RTTestCommon.h"

#import "RTThumbnailSupport.h"
#import "RTDeviceInformation.h"

SpecBegin(RTThumbnailSupport)

describe(@"thumbnail support", ^{
    
    __block RTThumbnailSupport *thumbnailSupport;
    __block RTDeviceInformation *deviceInformation;
    
    beforeEach(^{
        deviceInformation = mock([RTDeviceInformation class]);
        thumbnailSupport = [[RTThumbnailSupport alloc] initWithDeviceInformation:deviceInformation];
    });
    
    void (^testSupport)(CGSize, RTThumbnailResolution) = ^(CGSize expectedDimensions, RTThumbnailResolution expectedResolution) {
        expect(thumbnailSupport.dimensions.width).to.equal(expectedDimensions.width);
        expect(thumbnailSupport.dimensions.height).to.equal(expectedDimensions.height);
        expect(thumbnailSupport.resolution).to.equal(expectedResolution);
    };

    context(@"1X resolution", ^{
        afterEach(^{
            testSupport(CGSizeMake(75, 75), RTThumbnailResolution1X);
        });
        
        it(@"unsupported", ^{
            [given([deviceInformation iPhone4]) willReturnBool:NO];
            [given([deviceInformation iPhone5]) willReturnBool:NO];
            [given([deviceInformation iPhone6]) willReturnBool:NO];
            [given([deviceInformation iPhone6Plus]) willReturnBool:NO];
        });
    });
    
    context(@"2X resolution", ^{
        afterEach(^{
            testSupport(CGSizeMake(150, 150), RTThumbnailResolution2X);
        });
        
        it(@"iPhone 4", ^{
            [given([deviceInformation iPhone4]) willReturnBool:YES];
        });
        
        it(@"iPhone 5", ^{
            [given([deviceInformation iPhone5]) willReturnBool:YES];
        });
        
        it(@"iPhone 6", ^{
            [given([deviceInformation iPhone6]) willReturnBool:YES];
        });
    });
    
    context(@"3X resolution", ^{
        afterEach(^{
            testSupport(CGSizeMake(225, 225), RTThumbnailResolution3X);
        });
        
        it(@"iPhone 6 Plus", ^{
            [given([deviceInformation iPhone6Plus]) willReturnBool:YES];
        });
    });
});

SpecEnd