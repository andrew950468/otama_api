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

#ifndef NV_IP_GRAY_H
#define NV_IP_GRAY_H
#include "nv_core.h"

#ifdef __cplusplus
extern "C" {
#endif

#define NV_GRAY_B_RATE 0.11F
#define NV_GRAY_G_RATE 0.59F
#define NV_GRAY_R_RATE 0.30F

void nv_gray(nv_matrix_t *gray, const nv_matrix_t *bgr);
void nv_histgram_equalization(nv_matrix_t *eq, const nv_matrix_t *img, int channel);
void nv_contrast(nv_matrix_t *dest, int dch,
				 const nv_matrix_t *src, int sch,
				 float angle);
void nv_contrast_sigmoid(nv_matrix_t *dest, int dch,
						 const nv_matrix_t *src, int sch,
						 float gain);

#ifdef __cplusplus
}
#endif
#endif
