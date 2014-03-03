//
//  Business+Mapping.m
//
//  Created by Alexey Minaev on 10/3/13.
//
//

#import "Business+Mapping.h"

@implementation Business (Mapping)

static NSDictionary *_businessMappingDict = nil;

/*
 @property (nonatomic, retain) NSString * details;
 @property (nonatomic, retain) NSString * facebookUrl;
 @property (nonatomic, retain) NSString * title;
 @property (nonatomic, retain) NSString * pictureUrlString;
 @property (nonatomic, retain) NSString * address1;
 @property (nonatomic, retain) NSString * address2;
 @property (nonatomic, retain) NSString * contactEmail;
 @property (nonatomic, retain) NSString * contactName;
 @property (nonatomic, retain) NSString * contactPhone;
 @property (nonatomic, retain) NSString * country;
 @property (nonatomic) int32_t id;
 @property (nonatomic, retain) NSString * state;
 @property (nonatomic, retain) NSString * categoryName;
 @property (nonatomic, retain) Location *location;
 @property (nonatomic, retain) NSSet *offers;
 @property (nonatomic, retain) NSSet *rewards;
  @property (nonatomic, retain) NSString * zip;
 */


+ (NSDictionary*)mappingDictionaryFrontendKeysForBackendKeys {
  if (!_businessMappingDict) {
    _businessMappingDict = @{
                         @"name":@"name",
                         @"contact_email":@"contactEmail",
                         @"contact_name":@"contactName",
                         @"contact_phone":@"contactPhone",
                         @"country":@"country",
                         @"id":@"id",
                         @"state":@"state",
                         @"category_name":@"categoryName",
                         @"zip":@"zip",
                         @"latitude":@"location.latitude",
                         @"longitude":@"location.longitude",
                         @"address1":@"location.address1",
                         @"address2":@"location.address2",
                         @"picture_url":@"pictureUrlString"
                         };
  }
  return _businessMappingDict;
}

@end
