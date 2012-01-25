//
//  NSString+QS.h
//  KeywordMaker
//
//  Created by Casey Fleser on 1/24/12.
//  Copyright (c) 2012 Casey Fleser. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (QS)

- (NSString *)		stringByRemovingCharactersInSet: (NSCharacterSet *) inCharacterSet;

@end
