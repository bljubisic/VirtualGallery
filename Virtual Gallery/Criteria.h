//
//  Criteria.h
//  Virtual Gallery
//
//  Created by Bratislav Ljubisic on 10/08/2012.
//  Copyright (c) 2012 Gtech Beograd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Criteria : NSObject

@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSString *freeText;
@property (nonatomic, strong) NSNumber *year;
@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) NSString *tags;

-(id) initWithData: (NSArray *) searchData;
@end
