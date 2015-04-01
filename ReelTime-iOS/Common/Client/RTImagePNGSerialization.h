#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

// This is a bit of a hack to add support for PNGs into RestKit
// to maintain consistency in RTClient and avoid interacting directly
// with the underlying AFNetworking APIs.
//
// This should be revisited in the future if we begin doing
// more stuff with thumbnails and images.
@interface RTImagePNGSerialization : NSObject <RKSerialization>

@end
