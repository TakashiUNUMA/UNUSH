#
# anyver.gs
# producted by Tsuyoshi Sakai
#  URL: http://wind.geophys.tohoku.ac.jp/~sakai/lab/grads_script/index.html
# modified by Takashi Unuma, Kochi Univ.
# Last update: 2012/01/13
#

function main(args)
#--------+---------+---------+---------+---------+---------#
### help set ###############################################
if(subwrd(args,1)='help')
  help()
  return
endif
### help set ###############################################


### smoothing ##############################################
div=0.1
### smoothing ##############################################


### range set ##############################################
i=1
wrd=subwrd(args,i)
while(substr(wrd,1,1) = '-')
  if(wrd = '-d')
    i=i+1
    div=subwrd(args,i)
  endif
  i=i+1
  wrd=subwrd(args,i)
endwhile

lon1 = subwrd(args,i)
i=i+1
lon2 = subwrd(args,i)
i=i+1
lat1 = subwrd(args,i)
i=i+1
lat2 = subwrd(args,i)
i=i+1
z1 = subwrd(args,i)
i=i+1
z2 = subwrd(args,i)
i=i+1
var = subwrd(args,i)

'set grads off'
'set x 1'
'set y 1'
'set z 'z1' 'z2
lont = lon1
latt = lat1
### range set ##############################################


'collect 1 free'


### calculate ##############################################
if(lon1!=lon2)
  while (lont <= lon2)
    latt = lat1 + (lat2-lat1)*(lont-lon1) / (lon2-lon1)
    'collect 1 gr2stn('var','lont','latt')'
    lont = lont + (lon2-lon1)*div
  endwhile
  'set x 1 2'
  'set xaxis 'lon1' 'lon2
endif
if(lon1=lon2)
  while (latt <= lat2)
    lont = lon1 + (lon2-lon1)*(latt-lat1) / (lat2-lat1)
    'collect 1 gr2stn('var','lont','latt')'
    latt = latt + (lat2-lat1)*div
  endwhile
  'set x 1 2'
  'set xaxis 'lat1' 'lat2
endif  

'd coll2gr(1,-u)'
### calculate ##############################################

'collect 1 free'
return

#--------+---------+---------+---------+---------+---------#
### HELP ###################################################
function help()
say ''
say 'anyver.gs Ver. 0.1'
say ''
say ' anyver.gs [options] lon1 lon2 lat1 lat2 z1 z2 var'
say ' ex) anyver.gs 130.0 140.0 38.0 40.0 1 20 temp'
say ''
say '  -d num     : divide number (Default=0.1)'
say ' (lon1,lat1) : left point.'
say ' (lon2,lat2) : right point.'
say '  z1,z2      : vertical level. ( z1 = bottom , z2 = top )'
say ''
say ' ** This script can not draw undef data exactly, after Ver.2.0 **'
say ''
return
### HELP ###################################################
#--------+---------+---------+---------+---------+---------#
