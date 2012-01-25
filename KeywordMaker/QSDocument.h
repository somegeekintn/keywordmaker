//
//  QSDocument.h
//  KeywordMaker
//
//  Created by Casey Fleser on 1/24/12.
//  Copyright (c) 2012 Casey Fleser. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface QSDocument : NSDocument <NSTableViewDataSource>
{
	NSMutableDictionary		*_wordCount;
	NSMutableArray			*_wordList;
}

@property (nonatomic, retain) NSString	*queryKey;
@property (nonatomic, retain) NSString	*countKey;

@end
