//
//  TEXASView.m
//  TEXAS
//
//  Created by Uli Kusterer on 28.01.19.
//  Copyright © 2019 Uli Kusterer. All rights reserved.
//

#import "TEXASView.h"
#import "TEXASRenderer.hpp"
#import "TEXASLayouter.hpp"

@interface TEXASView ()
{
	size_t cursorPos;
	TEXASCharacterHitPart hitEdge;
}
@end

@implementation TEXASView

- (void)drawRect:(NSRect)dirtyRect
{
	TEXASRenderer	renderer;
	renderer.SetY(self.bounds.size.height);
	//renderer.SetTextStyle(TEXASBoxedStyle);
	
	TEXASLayouter layouter;
	layouter.text = "ABCDEFGHIJKLMNOPQRSTUVWXYZ Ä Ö Ü\nabcdefghijklmnopqrstuvwxyz ä ö ü\n0123456789\n.,?/:;'\"()! -\nHello World! Grün ist schön!";
	layouter.lineWidth = self.bounds.size.width;
	layouter.CalculateLineRuns(renderer);
	layouter.Draw(renderer, cursorPos, hitEdge);
}

-(void)	mouseDragged:(NSEvent *)event
{
	[self mouseDown: event
];
}

-(void)	mouseDown:(NSEvent *)event
{
	NSPoint clickPos = [self convertPoint: event.locationInWindow fromView: nil];
	
	TEXASRenderer	renderer;
	renderer.SetY(self.bounds.size.height);
	
	TEXASLayouter layouter;
	layouter.text = "ABCDEFGHIJKLMNOPQRSTUVWXYZ Ä Ö Ü\nabcdefghijklmnopqrstuvwxyz ä ö ü\n0123456789\n.,?/:;'\"()! -\nHello World! Grün ist schön!";
	layouter.lineWidth = self.bounds.size.width;
	layouter.CalculateLineRuns(renderer);
	cursorPos = layouter.OffsetAtXY(renderer, clickPos.x, clickPos.y, &hitEdge);
	
	NSLog(@"cursorPos = %zu", cursorPos);
	
	[self setNeedsDisplay: YES];
}

@end
