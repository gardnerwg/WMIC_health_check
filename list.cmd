Echo off
rem This is a sample wmic cmd file that will take the input of a columnar text file listing the servers you wish to run
rem WMI queries agains. WMIC is command line WMI and uses common aliases instead of WQLto get information out of a WMI
rem repository. 
rem
rem This particular sample will get a servername, query it for OS, QFE, CPU, MEM, DISK vaules and stick them into a html
rem formatted file for viewing. The directory that the wmic cmd file is run from will be the container for the html files
rem
rem ***  NOTE ***
rem Create a simple text file with a list of Windows servers you want to examine - note these names mnust be Netbios names 
rem 
rem	The next few lines of echo's are to create the HTML to setup the page - 
rem	I've added a bunch of carrots to allow the required greater than and less than symbols to echo properly
rem	These echo's can be eliminated if you put all the required "header" HTML into a file and redirect it
rem	into the front of the target HTML file with a copy or type command - makes the batch file easier to read
rem
echo 	^<HTML^>^<HEAD^>^<TITLE^>Sample Server Status Page ^</TITLE^>^</HEAD^>	> list.html
echo	^<BODY BGCOLOR="#FFFFFF" TEXT="#000000" LINK="#0000FF" VLINK="#800080"^>		>> list.html
echo	^<h1 align="center"^>^<b^>^<font face="Arial" size="+4" color="Red"^>Ecetera Server Monitoring Page^</font^>^</b^>^</h1^>		>> list.html
echo	^<p align="center"^>^<table border="1" width="600"^>					>> list.html
rem
rem	Table headers on the page are defined here, should you want to add more...
rem
echo	^<tr^>^<td^>^<B^>Server Name^</td^>			>> list.html
echo	^<td^>^<B^>OS Info^</td^>				>> list.html
echo	^<td^>^<B^>Patches^</td^>				>> list.html
echo	^<td^>^<B^>CPU Info^</td^>				>> list.html
echo	^<td^>^<B^>MEM Info^</td^>				>> list.html
echo	^<td^>^<B^>Disk Info^</td^>^</B^>^</tr^>^</p^>		>> list.html
rem
rem
rem	The loop below does all the heavy lifting
rem
for /F %%i in (serverlist.txt) do (
	echo Processing %%i...
	wmic /Failfast:on /node:"%%i" /output:"%%i_OS.html" OS Get /All /format:"%WINDIR%\System32\wbem\en-us\hform.xsl"
	wmic /Failfast:on /node:"%%i" /output:"%%i_qfe.html" QFE where "Description<>''" Get /All /format:"%WINDIR%\System32\wbem\en-us\htable.xsl"
	wmic /Failfast:on /node:"%%i" /output:"%%i_cpu.html" CPU get Name, DataWidth, CurrentClockSpeed, LoadPercentage  /format:"%WINDIR%\System32\wbem\en-us\htable.xsl"
	wmic /Failfast:on /node:"%%i" /output:"%%i_mem.html" OS get FreePhysicalMemory,TotalVirtualMemorySize,FreeVirtualMemory  /format:"%WINDIR%\System32\wbem\en-us\htable.xsl"
	wmic /Failfast:on /node:"%%i" /output:"%%i_drives.html" logicaldisk get caption, description, filesystem, size, freespace, compressed /format:"%WINDIR%\System32\wbem\en-us\htable.xsl"
	echo ^<tr^>^<td^>%%i^</td^> >>list.html 
	echo     ^<td^>^<a href="%%i_OS.html"^>OS Info^</a^>^</td^> >>list.html
	echo     ^<td^>^<a href="%%i_QFE.html"^>PATCHES^</a^>^</td^> >>list.html
	echo     ^<td^>^<a href="%%i_cpu.html"^>CPU^</a^>^</td^> >>list.html
	echo     ^<td^>^<a href="%%i_mem.html"^>MEM^</a^>^</td^> >>list.html
	echo     ^<td^>^<a href="%%i_drives.html"^>DRIVES^</a^>^</td^> >>list.html
	echo ^</tr^> >>list.html
)
echo ^<p align="center"^>^<b^>^<font size="+1" color="Red"^>^<BR^>Completed at >>list.html
time /T >> list.html
echo - on >> list.html
date /T >> list.html
echo ^</font^>^</b^>^<BR^>^</p^> >>list.html
Echo .
Echo DONE!!!

