$ref_file = get-content ./1.srt
$cari = [regex] "^[1-9][0-9]{0,3}\b\s*$"; 
$cari1 = [regex] "-->"; 
$temp = ""; 
$i= 0;

foreach($item in $ref_file){
	if($item -match $cari){$i = [int]$item; }
	if($item -match $cari1){$temp = $item ; }
}
$temp = $temp.split("-->")[3].replace("\s+", "").split("[:,\,]");

$i++;

# geser sedikit dalam microsecond
$temp[3] = 200; 

( get-content ./2.srt) | 
foreach-object{
	$sambung = "";
	if($_ -match $cari1){
		$hasil = $_ -split $cari1 ; 
		$first = $hasil[0].split("[:,\,]"); 
		$second = $hasil[1].split("[:,\,]"); 
		
		$first[3] = [int]$first[3] + $temp[3]; 
		if([int] $first[3] -gt 1000){
			$first[2] = [int]$first[2] + 1; 
			$first[3] = [int]$first[3] - 1000; 
		}
		$first[2] = [int] $first[2] + $temp[2]; 
		if([int] $first[2] -gt 60){
			$first[1] = [int]$first[1] + 1; 
			$first[2] = [int]$first[2] - 60; 
		}
		$first[1] = [int] $first[1] + $temp[1]; 
		if([int] $first[1] -gt 60){
			$first[0] = [int]$first[0] + 1; 
			$first[1] = [int]$first[1] - 60; 
		}
		$first[0] = [int] $first[0] + $temp[0]; 
			
		$second[3] = [int] $second[3] + $temp[3]; 
		if([int] $second[3] -gt 1000){
			$second[2] = [int]$second[2] + 1; 
			$second[3] = [int]$second[3] - 1000; 
		}
		$second[2] = [int] $second[2] + $temp[2]; 
		if([int] $second[2] -gt 60){
			$second[1] = [int]$second[1] + 1; 
			$second[2] = [int]$second[2] - 60; 
		}
		$second[1] = [int] $second[1] + $temp[1]; 
		if([int] $second[1] -gt 60){
			$second[0] = [int]$second[0] + 1; 
			$second[1] = [int]$second[1] - 60; 
		}
		$second[0] = [int] $second[0] + $temp[0]; 
		
		$sambung = $first[0]+":"+$first[1]+":"+$first[2]+","+$first[3]+" --> "+$second[0]+":"+$second[1]+":"+$second[2]+","+$second[3];
	}
	# sebenarnya nomornya mau dirubah juga tapi g jadi
	# $_ -replace "^.*-->.*$" , $sambung -replace $cari , $i  ;
	$_ -replace "^.*-->.*$" , $sambung ;		
	# if($_ -match $cari){
		# $i++; 
	# }
} |
set-content  ./2_baru.srt; 