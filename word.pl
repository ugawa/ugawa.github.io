#!/usr/bin/perl
# /docProps/core.xmlからlastModifiedByとapp.xmlからTotalTimeを出す
$TargetDir="/Users/ugawa/Desktop/Friday";
open(FILES,"ls $TargetDir |"); 
while(<FILES>){
	chomp;
	if(/.docx$/){
		$name=$_;
		$file="$TargetDir/$_";
		system("rm -fr $TargetDir/_aaa/");#前回の作業用Dirを消す
		mkdir "$TargetDir/_aaa/";
		$zip="$TargetDir/_aaa/aaa.zip";
		#print "$name,$zip\n";
		# Wordのファイルdocxから~.zipを作成
		system("cp '$file' $zip");
		#解凍してXMLを取り出す
		system("cd $TargetDir/_aaa;unzip aaa.zip>/dev/null 2>/dev/null");
		$RS=$/;
		$/='';
		open(XML,"<$TargetDir/_aaa/docProps/core.xml");
		$data = <XML>;
		$pos=index($data,'cp:lastModifiedBy>')+18;
		$lastModifiedBy=substr($data,$pos,50);
		$lastModifiedBy=~s/<\/.*$//;
		close(XML);
		open(XML,"<$TargetDir/_aaa/docProps/app.xml");
		$data = <XML>;
		$pos=index($data,'<TotalTime>')+11;
		$TotalTime=substr($data,$pos,10);
		$TotalTime=~s/<\/.*$//;
		close(XML);
		$/=$RS;
		print "$TotalTime\t$lastModifiedBy\t$name\n";#編集時間、最終編集者、ファイル名の印刷
		$RS=$/;
		#sleep 600;
	}
}
close(FILES);

__END__