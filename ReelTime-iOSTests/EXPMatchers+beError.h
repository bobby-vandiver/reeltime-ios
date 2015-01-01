#import <Expecta/Expecta.h>

EXPMatcherInterface(beError, (NSString *expectedDomain, NSInteger expectedCode));

#define beError beError