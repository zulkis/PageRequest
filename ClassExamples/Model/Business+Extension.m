//
//  Business+Extension.m
//
//  Created by Alexey Minaev on 10/3/13.
//
//

#import "Business+Extension.h"
#import "HTTPClient.h"
#import "Location+Extension.h"
#import "LocationManager.h"

@implementation Business (Extension)

+ (id)createEntity {
  Business *b = [super createEntity];
  b.location = [Location createEntity];
  return b;
}

+ (id)createInContext:(NSManagedObjectContext *)context {
  Business *b = [super createInContext:context];
  b.location = [Location createInContext:context];
  return b;
}

- (NSString *)sharingText {
  return [NSString stringWithFormat:@"Great offers in %@ at %@", self.name, self.location.address1];
}

+ (void)requestParamsForType:(BusinessRequestType)type paramsBlock:(void(^)(NSDictionary *dict, NSError *error))paramsBlock {
  switch (type) {
    case BusinessRequestTypeAll:
      paramsBlock(@{}, nil);
      break;
    case BusinessRequestTypeCurrentLocation: {
      [[LocationManager sharedInstance] getCurrentLocation:^(CLLocation *location, NSError *error) {
        if (error) {
          paramsBlock(@{}, error);
        } else {
#ifdef DEBUG
          paramsBlock(@{@"latitude": @(location.coordinate.latitude), @"longitude":@(location.coordinate.longitude), @"radius":@100000}, error);
#else
          paramsBlock(@{@"latitude": @(location.coordinate.latitude), @"longitude":@(location.coordinate.longitude)}, error);
#endif
        }
      }];
    }
      break;
    default:
      return;
  }
}

+ (AFHTTPRequestOperation*)pagedUpdateModelFromPath:(NSString*)path
                                         withParams:(NSDictionary*)params
                                          inContext:(NSManagedObjectContext*)context
                                         completion:(void(^)(NSError* error, NSUInteger currentPage, NSUInteger lastPage))completion {
  return [self baseUpdateModelFromPath:path withParams:params inContext:context completion:^(NSDictionary *data, NSError *error) {
    if (error) {
      completion(error, NAN, NAN);
    } else {
      completion(nil, [data[@"page"] unsignedIntegerValue], [data[@"total_pages"] unsignedIntegerValue]);
    }
  }];
}

+ (AFHTTPRequestOperation*)updateModelFromPath:(NSString*)path
                                    withParams:(NSDictionary*)params
                                     inContext:(NSManagedObjectContext*)context
                                    completion:(void(^)(NSError* error))completion {
  return [self baseUpdateModelFromPath:path withParams:params inContext:context completion:^(NSDictionary *data, NSError *error) {
    completion(error);
  }];
}

+ (AFHTTPRequestOperation*)baseUpdateModelFromPath:(NSString*)path
                                        withParams:(NSDictionary*)params
                                         inContext:(NSManagedObjectContext*)context
                                        completion:(void(^)(NSDictionary *data, NSError *error))completion {
  return [HTTPClient sendGETJSONRequestWithAction:path params:params completion:^(WebResponse *webResponse) {
    [webResponse.data[@"businesses"] enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
      Business *business = [Business createInContext:context];
      [business setValuesWithDictionary:obj];
    }];
    [context saveOnlySelfAndWait];
    completion(webResponse.data, webResponse.error);
  }];
}

@end
