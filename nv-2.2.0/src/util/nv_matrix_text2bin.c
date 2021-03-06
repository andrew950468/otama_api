/*
 * This file is part of libnv.
 *
 * Copyright (C) 2008-2012 nagadomi@nurs.or.jp
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License,
 * or any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#include "nv_core.h"
#include "nv_ml.h"
#include "nv_io.h"

static void
print_usage(void)
{
	puts("nv_text2bin text_matrix_file binary_matrix_file\n"
		 "    -h       display this help and exit.\n"
		);
}

int
main(int argc, char **argv)
{
	const char *text = NULL;
	const char *bin = NULL;
	int opt;
	nv_matrix_t *mat;
	
	while ((opt = nv_getopt(argc, argv, "h")) != -1){
		switch (opt) {
		case 'h':
			print_usage();
			return 0;
		default:
			print_usage();
			return 0;
		}
	}
	argc -= nv_getopt_optind;
	argv += nv_getopt_optind;
	if (argc != 2) {
		print_usage();
		return -1;
	}
	text = argv[0];
	bin = argv[1];	

	mat = nv_load_matrix_text(text);
	if (mat == NULL) {
		fprintf(stderr, "error : %s\n", text);
		return -1;
	}
	nv_save_matrix_bin(bin, mat);

	nv_matrix_free(&mat);
	
	return 0;
}
