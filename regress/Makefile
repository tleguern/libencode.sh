SHELLS?=sh
#SHELLS+=dash
#SHELLS+=bash
#SHELLS+=mksh

test:
	@for shell in ${SHELLS}; do \
		echo "$$shell:"; \
		for script in *.sh; \
		do \
			echo -n " - $$script: "; \
			$$shell ./$$script > /dev/null 2>&1; \
			echo $$?; \
		done; \
	done

