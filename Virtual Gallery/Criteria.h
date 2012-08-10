//
//  Criteria.h
//  Virtual Gallery
//
//  Created by Bratislav Ljubisic on 10/08/2012.
//  Copyright (c) 2012 Gtech Beograd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Criteria : NSObject

@property (nonatomic, weak) NSString *category;
@property (nonatomic, weak) NSString *freeText;
@property (nonatomic, weak) NSNumber *year;
@property (nonatomic, weak) NSString *author;
@property (nonatomic, weak) NSString *tags;

@end
