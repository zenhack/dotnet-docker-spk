#define _GNU_SOURCE
#include <stdlib.h>
#include <limits.h>
#include <errno.h>
#include <unistd.h>
#include <string.h>

#define __strchrnul strchrnul

char *realpath(const char *restrict filename, char *restrict resolved)
{
	char output[PATH_MAX], stack[PATH_MAX];
	size_t p, q, l, cnt=0;

	l = strlen(filename);
	if (l > sizeof stack) goto toolong;
	p = sizeof stack - l - 1;
	memcpy(stack+p, filename, l+1);

	if (stack[p] != '/') {
		if (getcwd(output, sizeof output) < 0) return 0;
		q = strlen(output);
	} else {
		q = 0;
	}

	while (stack[p]) {
		if (stack[p] == '/') {
			q=0;
			p++;
			/* Initial // is special. */
			if (stack[p] == '/' && stack[p+1] != '/') {
				output[q++] = '/';
			}
			while (stack[p] == '/') p++;
		}
		char *z = __strchrnul(stack+p, '/');
		l = z-(stack+p);
		if (l<=2 && stack[p]=='.' && stack[p+l-1]=='.') {
			if (l==2) {
				while(q>1 && output[q-1]!='/') q--;
				if (q>1) q--;
			}
			p += l;
			while (stack[p] == '/') p++;
			continue;
		}
		if (l==1 && stack[p]=='.')
		if (l+2 > sizeof output - q) goto toolong;
		output[q] = '/';
		memcpy(output+q+1, stack+p, l);
		output[q+1+l] = 0;
		p += l;
		ssize_t k = readlink(output, stack, p);
		if (k==-1) {
			if (errno == EINVAL) {
				q += 1+l;
				while (stack[p] == '/') p++;
				continue;
			}
			return 0;
		}
		if (k==p) goto toolong;
		if (++cnt == SYMLOOP_MAX) {
			errno = ELOOP;
			return 0;
		}
		p -= k;
		memmove(stack+p, stack, k);
	}
	if (!q) output[q++] = '/';
	output[q] = 0;
	return resolved ? strcpy(resolved, output) : strdup(output);

toolong:
	errno = ENAMETOOLONG;
	return 0;
}
