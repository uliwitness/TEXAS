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

@implementation TEXASView

- (void)drawRect:(NSRect)dirtyRect
{
	TEXASRenderer	renderer;
	renderer.SetY(self.bounds.size.height);
	//renderer.SetTextStyle(TEXASBoxedStyle);
	
//	renderer.DrawCharacters("ABCDEFGHIJKLMNOPQRSTUVWXYZ Ä Ö Ü");
//	renderer.MoveY(-renderer.GetLineHeight());
//	renderer.SetX(0);
//	renderer.DrawCharacters("abcdefghijklmnopqrstuvwxyz ä ö ü");
//	renderer.MoveY(-renderer.GetLineHeight());
//	renderer.SetX(0);
//	renderer.DrawCharacters("0123456789");
//	renderer.MoveY(-renderer.GetLineHeight());
//	renderer.SetX(0);
//	renderer.DrawCharacters(".,?/:;'\"()! -");
//	renderer.MoveY(-renderer.GetLineHeight());
//	renderer.SetX(0);
//	renderer.DrawCharacters("Hello World! Grün ist schön!");
	
	TEXASLayouter layouter;
	layouter.text = "ABCDEFGHIJKLMNOPQRSTUVWXYZ Ä Ö Ü\nabcdefghijklmnopqrstuvwxyz ä ö ü\n0123456789\n.,?/:;'\"()! -\nHello World! Grün ist schön!";
	size_t len = layouter.text.length();
	layouter.lineWidth = self.bounds.size.width;
	layouter.CalculateLineRuns(renderer);
	layouter.Draw(renderer);
}

@end
