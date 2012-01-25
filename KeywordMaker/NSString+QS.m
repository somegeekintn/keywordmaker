//
//  NSString+QS.m
//  KeywordMaker
//
//  Created by Casey Fleser on 1/24/12.
//  Copyright (c) 2012 Casey Fleser. All rights reserved.
//

#import "NSString+QS.h"

@implementation NSString (QS)

- (NSString *) stringByRemovingCharactersInSet: (NSCharacterSet *) inCharacterSet
{
	NSMutableString		*newString = [self mutableCopy];
	
	if ([newString length]) {
		for (NSInteger idx=[self length]-1; idx>=0; idx--) {
			if ([inCharacterSet characterIsMember: [newString characterAtIndex: idx]])
				[newString deleteCharactersInRange: NSMakeRange(idx, 1)];
		}
	}
	
	return [newString autorelease];
}

@end
