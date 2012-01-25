//
//  QSApplicationDelegate.m
//  KeywordMaker
//
//  Created by Casey Fleser on 1/24/12.
//  Copyright (c) 2012 Casey Fleser. All rights reserved.
//

#import "QSApplicationDelegate.h"

@implementation QSApplicationDelegate

- (void) applicationDidFinishLaunching: (NSNotification *) inNotification
{
	[[NSDocumentController sharedDocumentController] openDocument: nil];
}

- (BOOL) applicationShouldOpenUntitledFile: (NSApplication *) inSender
{
	return NO;
}

@end
