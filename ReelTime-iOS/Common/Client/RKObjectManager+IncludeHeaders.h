#import <RestKit/RestKit.h>

@interface RKObjectManager (IncludeHeaders)

- (void)getObject:(id)object
             path:(NSString *)path
       parameters:(NSDictionary *)parameters
          headers:(NSDictionary *)headers
          success:(void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success
          failure:(void (^)(RKObjectRequestOperation *operation, NSError *error))failure;

@end
