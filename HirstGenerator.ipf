#pragma TextEncoding = "MacRoman"
#pragma rtGlobals=3		// Use modern global access method and strict wave access.
// Load this picture from:
// http://www.damienhirst.com/cache/images/dhs3823_0_1280_0.jpg
// ‘Abalone Acetone Powder’ (1991). Photographed by Alex Hartley © Damien Hirst and Science Ltd. All rights reserved, DACS 2012
// From local disk, using ImageLoad/P=Hirst/T=jpeg/Q/N=hirst/G "dhs3823_0_1280_0.jpg"
// Place marquee on top left spot to get topV and leftV; and then bottom right
// count spots across (ww) and spots down (hh)
Function GetHirstPalette(topV,leftV,bottomV,rightV,ww,hh,m0)
	Variable topV,leftV,bottomV,rightV,ww,hh
	Wave m0
	// make wave for xloc and yloc
	Make/O/N=(ww) xLoc
	Make/O/N=(hh) yLoc
	xLoc = floor(leftV + (p * ((rightV - leftV) / (ww - 1))))
	yLoc = floor(topV + (p * ((bottomV - topV) / (hh - 1))))
	// Make a 3-clomun wave to store the raw colours
	Make/O/N=(ww*hh,3) H_RawPalette
	// Store the unitary positions of each spot
	Make/O/N=(ww*hh,2) H_SpotLocs
	
	Variable i,j,k, l=0
	
	for(i = 0; i < ww; i += 1)
		for(j = 0; j < hh; j += 1)
			for(k = 0; k < 3; k += 1)
				// take 3x3 px sub-matrix for each color
				Duplicate/O/FREE/RMD=[xLoc[i]-1,xLoc[i]+1][yLoc[j]-1,yLoc[j]+1][k] m0,m1
				// store color for each channel
				H_RawPalette[l][k] = round(mean(m1))
			endfor
			H_SpotLocs[l][0] = xLoc[i]
			H_SpotLocs[l][1] = yLoc[j]
			l += 1
		endfor
	endfor
	TestHirstPalette(topV,leftV,bottomV,rightV,ww,hh)
End

Function TestHirstPalette(topV,leftV,bottomV,rightV,ww,hh)
	Variable topV,leftV,bottomV,rightV,ww,hh
	WAVE/Z H_RawPalette,H_SpotLocs
	Duplicate/O H_RawPalette,H_RawPalette16
	H_RawPalette16 *=257
	KillWindow/Z spotTest
	Display/N=spotTest/W=(186,45,854,672) H_SpotLocs[][1] vs H_SpotLocs[][0]
	ModifyGraph/W=spotTest mode=3,marker=19,msize=11,mrkThick=0,zColor(H_SpotLocs)={H_RawPalette16,*,*,directRGB,0}
	ModifyGraph/W=spotTest margin=6
	ModifyGraph/W=spotTest noLabel=2,axThick=0,standoff=0
	ModifyGraph/W=spotTest width={Plan,1,bottom,left}
	SetAxis/W=spotTest left bottomV+topV,0
	SetAxis/W=spotTest bottom 0,rightV+leftV
	SetDrawLayer/W=spotTest UserBack
	SetDrawEnv/W=spotTest xcoord= bottom,ycoord= left
	SetDrawEnv/W=spotTest fillfgc= (63222,63222,63222),linethick= 0.00
	DrawRect/W=spotTest 0,0,rightV+leftV,bottomV+topV
	SetDrawLayer/W=spotTest UserFront
End

	