#pragma TextEncoding = "MacRoman"
#pragma rtGlobals=3		// Use modern global access method and strict wave access.

/// @param	ww	variable to determine how many spots there will be across
/// @param	hh	varuable to determine how many spots there will be down
Function HirstGenerator(ww,hh)
	Variable ww,hh
	
	// set up palette
	WAVE/Z H_RawPalette16
	if(!WaveExists(H_RawPalette16))
		Print "Please load H_RawPalette16"
	endif
	StatsResample/N=(ww*hh)/MC/Q H_RawPalette16
	WAVE/Z M_Resampled
	Duplicate/O M_Resampled, H_RandomPalette16 
	// Make a 2-column wave for spot locations
	Make/O/N=(ww*hh,2) H_SpotLocs
	// Spot inset is 22,22
	// Spot spacing is 83
	H_SpotLocs[][0] = 22 + (floor(p / hh) * 83)
	H_spotLocs[][1] = 22 + (mod(p,hh) * 83)
	Variable graphWidth = floor((2 * 22) + ((ww-1) * 83) * 0.52)
	Variable graphHeight = floor((2 * 22) + ((hh-1) * 83) * 0.52)
	KillWindow/Z spotTest
	Display/N=spotTest/W=(50,50,50+graphWidth,50+graphHeight) H_SpotLocs[][1] vs H_SpotLocs[][0]
	ModifyGraph/W=spotTest mode=3,marker=19,msize=11,mrkThick=0,zColor(H_SpotLocs)={H_RandomPalette16,*,*,directRGB,0}
	ModifyGraph/W=spotTest margin=1
	ModifyGraph/W=spotTest noLabel=2,axThick=0,standoff=0
	ModifyGraph/W=spotTest width={Plan,1,bottom,left}
	Variable axWidth = (2 * 22) + ((ww-1) * 83)
	Variable axHeight = (2 * 22) + ((hh-1) * 83)
	SetAxis/W=spotTest left axHeight,0
	SetAxis/W=spotTest bottom 0,axWidth
	SetDrawLayer/W=spotTest UserBack
	SetDrawEnv/W=spotTest xcoord= bottom,ycoord= left
	SetDrawEnv/W=spotTest fillfgc= (63222,63222,63222),linethick= 0.00
	DrawRect/W=spotTest 0,0,axWidth,axHeight
	SetDrawLayer/W=spotTest UserFront
	SavePICT/E=-5/RES=300 as "spotTest.png"
End

// --------------------------------------------------------------------------------------------

// Load this picture from:
// http://www.damienhirst.com/cache/images/dhs3823_0_1280_0.jpg
// ‘Abalone Acetone Powder’ (1991). Photographed by Alex Hartley © Damien Hirst and Science Ltd
// From local disk, using ImageLoad/P=Hirst/T=jpeg/Q/N=hirst/G "dhs3823_0_1280_0.jpg"
// Place marquee on top left spot to get topV and leftV; and then bottom right
// count spots across (ww) and spots down (hh)
// i.e. GetHirstPalette(22,22,1178,1260,16,15,hirst)
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
	MakeHirstReplica(ww,hh)
End

// This function will make a replica where the distances between spots are hard coded
Function MakeHirstReplica(ww,hh)
	Variable ww,hh
	
	// set up palette
	WAVE/Z H_RawPalette
	Duplicate/O H_RawPalette,H_RawPalette16
	H_RawPalette16 *=257
	// Make a 2-column wave for spot locations
	Make/O/N=(ww*hh,2) H_SpotLocs
	// Spot inset is 22,22
	// Spot spacing is 83
	H_SpotLocs[][0] = 22 + (floor(p / hh) * 83)
	H_spotLocs[][1] = 22 + (mod(p,hh) * 83)
	Variable graphWidth = floor((2 * 22) + ((ww-1) * 83) * 0.52)
	Variable graphHeight = floor((2 * 22) + ((hh-1) * 83) * 0.52)
	KillWindow/Z spotTest
	Display/N=spotTest/W=(50,50,50+graphWidth,50+graphHeight) H_SpotLocs[][1] vs H_SpotLocs[][0]
	ModifyGraph/W=spotTest mode=3,marker=19,msize=11,mrkThick=0,zColor(H_SpotLocs)={H_RawPalette16,*,*,directRGB,0}
	ModifyGraph/W=spotTest margin=6
	ModifyGraph/W=spotTest noLabel=2,axThick=0,standoff=0
	ModifyGraph/W=spotTest width={Plan,1,bottom,left}
	Variable axWidth = (2 * 22) + ((ww-1) * 83)
	Variable axHeight = (2 * 22) + ((hh-1) * 83)
	SetAxis/W=spotTest left axHeight,0
	SetAxis/W=spotTest bottom 0,axWidth
	SetDrawLayer/W=spotTest UserBack
	SetDrawEnv/W=spotTest xcoord= bottom,ycoord= left
	SetDrawEnv/W=spotTest fillfgc= (63222,63222,63222),linethick= 0.00
	DrawRect/W=spotTest 0,0,axWidth,axHeight
	SetDrawLayer/W=spotTest UserFront
End