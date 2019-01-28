//
//  TEXASLayouter.cpp
//  TEXAS
//
//  Created by Uli Kusterer on 28.01.19.
//  Copyright © 2019 Uli Kusterer. All rights reserved.
//

#include "TEXASLayouter.hpp"
#include <iostream>


void TEXASLayouter::CalculateLineRuns(TEXASRenderer& renderer) {
	lineRuns.clear();
	
	TEXASLineRun run;
	run.lineStart = 0;
	int currLineWidth = 0;

	for (size_t x = 0; x < text.length();) {
		size_t measuredChars = 0;
		currLineWidth += renderer.WidthOfCharacters(text.c_str() + x, &measuredChars, lineWidth, '\n');
		run.lineEnd = x + measuredChars;
		run.hardBreak = text[run.lineEnd] == '\n';
		
		lineRuns.push_back(run);

		if (run.hardBreak) {
			x = run.lineStart = run.lineEnd + 1;
		} else {
			x = run.lineStart = run.lineEnd;
		}
	}
}


void	TEXASLayouter::Draw(TEXASRenderer& renderer) {
	int leftEdge = renderer.GetX();
	for(TEXASLineRun& run : lineRuns) {
		std::string currLine = text.substr(run.lineStart, run.lineEnd -run.lineStart);
		renderer.DrawCharacters(currLine.c_str());
		renderer.SetX(leftEdge);
		renderer.MoveY(-renderer.GetLineHeight());
	}
}
