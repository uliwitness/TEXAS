//
//  TEXASLayouter.cpp
//  TEXAS
//
//  Created by Uli Kusterer on 28.01.19.
//  Copyright © 2019 Uli Kusterer. All rights reserved.
//

#include "TEXASLayouter.hpp"


void TEXASLayouter::CalculateLineRuns() {
	lineRuns.clear();
	
	size_t lastPos = 0;
	
	while (true) {
		TEXASLineRun run;
		run.lineStart = lastPos;
		run.lineEnd = text.find('\n', lastPos);
		if (run.lineEnd == std::string::npos) {
			run.lineEnd = text.length();
			lineRuns.push_back(run);
			break;
		}
		lineRuns.push_back(run);
		lastPos = run.lineEnd + 1;
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
