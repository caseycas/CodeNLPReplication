package slp.ast.parser;
import java.io.File;

import org.apache.commons.io.filefilter.IOFileFilter;

public class JavaFileFilter implements IOFileFilter {

		@Override
		public boolean accept(File arg0) {
			return arg0.getAbsolutePath().matches(".*\\.java");
		}

		@Override
		public boolean accept(File arg0, String arg1) {
			return accept(arg0);
		}
		
}
