//
//  PageRequesting.h
//
//  Created by Alexey Minaev on 10/4/13.
//
//

#ifndef UberLoop_PageRequesting_h
#define UberLoop_PageRequesting_h

@class AFHTTPRequestOperation;

@protocol PageRequesting <NSObject>

@required
+ (AFHTTPRequestOperation*)pagedUpdateModelFromPath:(NSString*)path
                                         withParams:(NSDictionary*)params
                                          inContext:(NSManagedObjectContext*)context
                                         completion:(void(^)(NSError* error, NSUInteger currentPage, NSUInteger lastPage))completion;

@end

#endif
