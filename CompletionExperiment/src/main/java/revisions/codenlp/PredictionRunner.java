package revisions.codenlp;

import java.io.File;
import java.util.ArrayList;
import java.util.Collection;
import java.util.DoubleSummaryStatistics;
import java.util.List;
import java.util.function.Function;
import java.util.stream.Collectors;
import java.util.stream.IntStream;
import java.util.stream.Stream;

import slp.core.lexing.runners.LexerRunner;
import slp.core.modeling.Model;
import slp.core.modeling.runners.Completion;
import slp.core.modeling.runners.ModelRunner;
import slp.core.translating.Vocabulary;
import slp.core.util.Pair;

public class PredictionRunner extends ModelRunner{

	//Self Testing should be protected I think?
	public PredictionRunner(Model model, LexerRunner lexerRunner, Vocabulary vocabulary) {
		super(model, lexerRunner, vocabulary);
		// TODO Auto-generated constructor stub
	}
	
	private DoubleSummaryStatistics getFileStatsFlat(Stream<List<Double>> fileProbs) {
			return fileProbs.flatMap(f -> f.stream()
						.skip(1))
					.mapToDouble(p -> p).summaryStatistics();
	}
	
	public DoubleSummaryStatistics getCompletionStatsFlat(List<Completion> completions) {
		List<Double> MRRs = completions.stream()
			.map(c -> toMRR(c.getRank()))
			.collect(Collectors.toList());
		return getFileStatsFlat(Stream.of(MRRs));
	}

}
