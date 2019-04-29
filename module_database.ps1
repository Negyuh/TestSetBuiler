Param(
    [string]$interface,[string]$part,[string]$records,[string]$new,[string]$update,[string]$nok,[string]$lpath
)

#-------------------------------------------------------------------------------------------------------------------
Function countsource ($interface){
 $amntsources=0
 $tempname=Get-ChildItem -Path "O:\Controles" -Filter "ServiceNOW_CMDB_$interface"|Get-ChildItem -Filter "check*"
 if($tempname -eq $null){
    logwrite("No control file of interface: $interface found, assuming count = 1")
    $amntsources=1
    return $amntsources
    break}
 $totalname=$tempname.DirectoryName + "\"+ $tempname.Name
 $imp=Import-Csv $totalname  -Delimiter ';'
            for($i=0;$i -lt $imp.Count;$i++){
                #testfilewrite $imp.filepath[$i]
                if($imp.filepath[$i] -like "*baseline*"){continue} 
                 if($imp.filepath[$i] -like "*tmp*"){continue}
                 if($imp.filepath[$i] -like "*support*"){continue} 
                 if([string]::IsNullOrWhiteSpace($imp.filepath[$i])){continue}
                 else{
                    $amntsources=$amntsources + 1
                }
            }return $amntsources
    }
#-------------------------------------------------------------------------------------------------------------------
Function LogWrite
{Param ([string]$logstring)
    Add-content $lpath -value $logstring
}
#-------------------------------------------------------------------------------------------------------------------

Function testfilewrite ([string]$addstring, [string]$interfacenaam)
{   
   #Check clear uniqueness checkbox to create unique or non-unique csv files
   if($chbClearUniqueness.Checked -eq $false){
        $tspath=$outputpath + "\" + $inf + "\generate" + "\$interfacenaam" + "_$uniq.csv"}
    Else {$tspath=$outputpath + "\" + $inf + "\generate" + "\$interfacenaam" + ".csv"}
   if(!(Test-Path ($outputpath + "\" + $inf + "\generate" + "\" ))){
        New-Item -ItemType directory -Path ($outputpath + "\" + $inf + "\generate" + "\" )}
   Add-content $tspath -value $addstring
}
#-------------------------------------------------------------------------------------------------------------------

Function GenCI {
# this function generates a set of key values for a CI
if($ciname){
Clear-Variable ciname}
if($serial){
Clear-Variable serial}
if($devicename){
Clear-Variable devicename}
if($ipaddress){
Clear-Variable ipaddress}
if($hash){
Clear-Variable hash}
if($cisid){
Clear-Variable cisid}
if($assettag){
Clear-Variable assettag}
if($macaddr){
Clear-Variable macaddr}
if($powerstate){
Clear-Variable powerstate}
if($cistatus){
Clear-Variable cistatus}
if($ciactive){
Clear-Variable ciactive}
if($ciram){
Clear_Variable ciram}


# Now do a loop of $amountall times to generate values to be used for the substitution of variables in testdata files
foreach($ci in (1..($amountall+ ([int]$anmnw * [int]$amntsource)))){
    Set-Variable -Name "CISIDtmp" -Value (-join ((48..57) + (97..122) | Get-Random -Count 32 | % {[char]$_}))
    [array]$cisid += $cisidtmp
    Set-Variable -Name "CISIDtmp2" -Value (-join ((48..57) + (97..122) | Get-Random -Count 32 | % {[char]$_}))
    [array]$cisid2 += $cisidtmp2
    Set-Variable -Name "CISIDtmp3" -Value (-join ((48..57) + (97..122) | Get-Random -Count 32 | % {[char]$_}))
    [array]$cisid3 += $cisidtmp3
    Set-Variable -Name "CIName$ci" -value "dev_$ci"
    [array]$ciname += "CIName$ci"
    Set-Variable -Name "serial" -Value (-join ((48..57)  | Get-Random -Count 32 | % {[char]$_}))
    [array]$serialnumber += "$serial"
    [array]$devicename += "dev_$ci"
    [array]$Ipaddress += "10.245.143.$ci"
    [array]$assettag += "CI123$ci"
    Set-Variable -Name MACaddress -Value ((0..5 | ForEach-Object { '{0:x}{1:x}' -f (Get-Random -Minimum 0 -Maximum 15),(Get-Random -Minimum 0 -Maximum 15)})  -join ':')
    [array]$macaddr += $MACaddress
    Set-Variable -Name 'status' -Value 'PoweredOn'
    [array]$cistatus += $status
    Set-Variable -Name "active" -Value 'active'
    [array]$ciactive += $active
    Set-Variable -Name "powerstat" -Value 'PoweredOn'
    [array]$powerstate += $powerstat
    Set-Variable -Name "lastsee" -Value $logdate
    [array]$lastseen += $lastsee
    Set-Variable -Name "ram" -Value '2048'
    [array]$ciram += $ram
    Set-Variable -Name "cpucr" -Value '1'
    [array]$cpucore +=$cpucr
    Set-Variable -Name "vcpucr" -Value '2'
    [array]$vcpu +=$vcpucr
    Set-Variable -Name "dbrelease1" -Value '12c'
    [array]$dbrelease +=$dbrelease1
    $xmlfav=[guid]::NewGuid() 
    [array]$xlfavorites += $xmlfav
    $xmlshort=[guid]::NewGuid() 
    [array]$xlshortcuts += $xmlshort
    $xmlconn=[guid]::NewGuid() 
    [array]$xlconnections += $xmlconn
    $nuuid= [guid]::NewGuid()
    Set-Variable -Name 'vuuid' -Value $nuuid
    [array]$ciuuid += $vuuid
   }

#code to generate Device model randomly
    for($m=1;$m -le ($amountall+ ([int]$anmnw * [int]$amntsources));$m++ ){
            $mod=Get-Random -Minimum 1 -Maximum 6
            Switch($mod){
                1 {$model='model1'
                   [array]$cimodel += $model}
                2 {$model='model2'
                   [array]$cimodel += $model}
                3 {$model='model3'
                   [array]$cimodel += $model}  
                4 {$model='model4'
                   [array]$cimodel += $model}    
                5 {$model='model5'
                   [array]$cimodel += $model} 
              }
                
            }

#code to generate database model randomly
    for($m=1;$m -le (($amountall+ ([int]$anmnw * [int]$amntsource)) + [int]$new);$m++ ){
            $mod=Get-Random -Minimum 1 -Maximum 6
            Switch($mod){
                1 {$dbmodel='MS SQL'
                   [array]$cidbmodel += $dbmodel
                   $dbnm= 'SQLDB'+ $m
                   [array]$cidbname += $dbnm}
                2 {$dbmodel='Oracle'
                   [array]$cidbmodel += $dbmodel
                   $dbnm= 'Orcl' + $m
                   [array]$cidbname += $dbnm}
                3 {$dbmodel='MySQL'
                   [array]$cidbmodel += $dbmodel
                   $dbnm= 'MySQL' + $m
                   [array]$cidbname += $dbnm}  
                4 {$dbmodel='IBM DB2'
                   [array]$cidbmodel += $dbmodel
                   $dbnm= 'IBMDB2' + $m
                   [array]$cidbname += $dbnm}    
                5 {$dbmodel='SAP HANA'
                   [array]$cidbmodel += $dbmodel
                   $dbnm= 'SAPHANA' + $m
                   [array]$cidbname += $dbnm} 
              }
                
            }
            

#code to generate alternate status values randomly to be used for updates
    for($u=1;$u -le $upd;$u++ ){
            $stat=Get-Random -Minimum 1 -Maximum 4
            Switch($stat){
                1 {$status='removed'
                   [array]$altcistatus += $status
                   $active='inactive'
                   [array]$altciactive += $active
                   $powerstat='PoweredOff'
                   [array]$altpowerstate += $powerstat
                   $lastsee= $sevendaysago
                   [array]$altlastseen += $lastsee
                   $ram='0'
                   [array]$altciram += $ram
                   $cpucr='1'
                   [array]$altcpucore +=$cpucr
                   $vcpucr='2'
                   [array]$altvcpu +=$vcpucr
                   $dbrelease2= '15c'
                   [array]$altdbrelease +=$dbrelease2}
                2 {$status='unknown'
                   [array]$altcistatus += $status
                   $active='unknown'
                   [array]$altciactive += $active
                   $powerstat='unknown'
                   [array]$altpowerstate += $powerstat
                   $lastsee= $sevendaysago
                   [array]$altlastseen += $lastsee
                   $ram='4096'
                   [array]$altciram += $ram
                   $cpucr='1'
                   [array]$altcpucore +=$cpucr
                   $vcpucr='2'
                   [array]$altvcpu +=$vcpucr
                   $dbrelease2= '13b'
                   [array]$altdbrelease +=$dbrelease2
                   } 
                3 {$status='PoweredOn'
                   [array]$altcistatus += $status
                   $active='down'
                   [array]$altciactive += $active
                   $powerstat='PoweredOn'
                   [array]$altpowerstate += $powerstat
                   $lastsee= $sevendaysago
                   [array]$altlastseen += $lastsee
                   $ram='8192'
                   [array]$altciram += $ram
                   $cpucr='2'
                   [array]$altcpucore +=$cpucr
                   $vcpucr='8'
                   [array]$altvcpu +=$vcpucr
                   $dbrelease2= '14c'
                   [array]$altdbrelease +=$dbrelease2
                   }     
              }
                
            }

# code for generation of not OK
if($amnnok -ge 1){
    for($i=1;$i -le $amnnok;$i++){
        [array]$cinamenok += "CIName$i"
        }
}


# A hash table will be filled and at the end of this function returned to the script base to be used by the other functions to produce the testfiles
    $hash = @{
        altaltdatelong= @($altaltdatelong)
        altciactive= @($altciactive)
        altcicpu= @($altcpucore)
        altciram= @($altciram)
        altCistatus= @($altcistatus)
        altcivcpu= @($altvcpu)
        altdatelong= @($altdatelong)
        altdateHorus= @($altdateHorus)
        altLastseen= @($altlastseen)
        altPowerState= @($altpowerstate)
        altdbrelease=@($altdbrelease)
        Amountall= @($amountall)
        Assettag = @($assettag)
        Ciactive= @($ciactive)
        cicpu= @($cpucore)
        cidbmodel= @($cidbmodel)
        cidbname= @($cidbname)
        CImodel= @($cimodel)
        cinamenok= @($cinamenok)
        ciram= @($ciram)
        Cistatus= @($cistatus)
        civcpu= @($vcpu)
        dbrelease=@($dbrelease)
        devicename = @($devicename)
        Ipaddress = @($Ipaddress)
        Lastseen= @($lastseen)
        MACaddress = @($macaddr)
        name= @($ciname)
        PowerState= @($powerstate)
        serial = @($serialnumber)
        sid= @($cisid)
        sid2= @($cisid2)
        sid3= @($cisid)
        uuid= @($ciuuid3)
        xmlconns= @($xlconnections)
        xmlfavo= @($xlfavorites)
        xmlshort= @($xlshortcuts)
        }
     return $hash
    }
  
#-------------------------------------------------------------------------------------------------------------------
Function supportgroups_db{
LogWrite('Starting creation of testset for interface database part: supportgroups')
$Interfacenaam='supportgroups'
    $firstline= ('Company,Department,Overall responsible group,CI Responsible group,Support group')
    testfilewrite $firstline $Interfacenaam
    for($i=0; $i -lt $amountall; $i++){
        $editline= ('KPN B.V.,BO KPN Retail,KPN-OPS N&I ACN WS-DevOps,KITS-IT-SAP,BO KPN Retail')
        if($hash1.altCistatus[$i] -ne $null){
            $edline=$editline -replace 'sysid',$hash1.sid[$i]  -replace 'name',$hash1.devicename[$i] -replace 'dbname',$hash1.cidbname[$i] -replace 'database',$hash1.cidbmodel[$i] -replace 'datum',$logdate -replace 'serial', $hash1.Serial[$i] -replace 'ipaddr', $hash1.ipaddress[$i] -replace 'assettag', $hash1.assettag[$i] -replace 'ciactive', $hash1.altciactive[$i] -replace 'powerstate', $hash1.altpowerstate[$i] -replace 'lastsee', $hash1.altlastseen[$i]  -replace 'ram',$hash1.altciram[$i]  -replace 'cpucore',$hash1.altcicpu[$i] -replace 'vcpu',$hash1.altcivcpu[$i]
            testfilewrite "$edline" "$Interfacenaam"}
        else{$edline=$editline -replace 'sysid',$hash1.sid[$i]  -replace 'name',$hash1.devicename[$i] -replace 'dbname',$hash1.cidbname[$i] -replace 'datum',$altdatelong -replace 'serial', $hash1.Serial[$i] -replace 'ipaddr', $hash1.ipaddress[$i] -replace 'assettag', $hash1.assettag[$i] -replace 'ciactive', $hash1.ciactive[$i] -replace 'powerstate', $hash1.powerstate[$i] -replace 'lastsee', $hash1.lastseen[$i]  -replace 'ram',$hash1.ciram[$i]  -replace 'cpucore',$hash1.cicpu[$i] -replace 'vcpu',$hash1.civcpu[$i]
             testfilewrite "$edline" "$Interfacenaam"}   
       }
       LogWrite('Finished creation of testset for interface database part: supportgroups')
       $progressbar.PerformStep()
}



Function CMDB_SAPLogon_CSV{
# increment partcounter for this part
$partcounter=1
# now the partcounter is used to compute the part increment so this part of the total amount of hash records will receive the right amount of hash records
$partincrement=$partcounter * $amntprt
$partstart=$partincrement - $amntprt
    LogWrite('Starting creation of testset for interface Database Relations part: SAPLogon')
    $Interfacenaam='CMDB_SAPLogon'
    $firstline= ('SAPversion;SAPfile;SAP_Company;SAP_Department;SAP_Identifier;SAP_Company_code;SAP_release;SAP_cpm_inst;SAP_Environment;SAP_SID;SAP_SID_DB;SAP_Instance_name;SAP_Instance_number;SAP_Hostname;SAP_Database;SAP_Instance;SAP_System;SAP_Status;Filename;Discoverydate')
    testfilewrite $firstline $Interfacenaam
    for($i=$partstart; $i -le ([int]$partincrement + [int]$new -1); $i++){
        if($i -lt $update){
            for($w=1;$w -le $update;$w++){
                $editline='"";"";"KPN";"";"KPN (ERP 6.06 - PRD) - DB1 HANA (name 18)";"KPN";"ERP 6.06";"DB";"PRD";"dbnme";"";"name";"18";"name";"KPN.DB1";"KPN_name";"DB1_KPN_18";"status";"SAPUILandscape";"altdatelong"'
                $edline=$editline -replace 'sysid',$hash1.sid[$i]  -replace 'altdatelong',$hash1.altaltdatelong  -replace 'name',$hash1.devicename[$i] -replace 'dbnme',$hash1.dbrelease[$i] -replace 'datum',$altdatelong -replace 'date',$altdateshort -replace 'status', $hash1.altcistatus[$i] -replace 'ipaddr', $hash1.ipaddress[$i] -replace 'assettag', $hash1.assettag[$i] -replace 'active', $hash1.Ciactive[$i] -replace 'status', $hash1.altcistatus[$i] -replace 'MAC', $hash1.MACaddress[$i] -replace 'model', $hash1.cimodel[$i]
                testfilewrite "$edline" "$Interfacenaam"
                $i++
                continue
                } 
            }
        $editline='"";"";"KPN";"";"KPN (ERP 6.06 - PRD) - DB1 HANA (name 18)";"KPN";"ERP 6.06";"DB";"PRD";"dbnme";"";"name";"18";"name";"KPN.DB1";"KPN_name";"DB1_KPN_18";"In use";"SAPUILandscape";"altdatelong"'
        $edline=$editline -replace 'sysid',$hash1.sid[$i]  -replace 'altdatelong',$hash1.altaltdatelong  -replace 'name',$hash1.devicename[$i] -replace 'dbnme',$hash1.dbrelease[$i] -replace 'datum',$altdatelong -replace 'date',$altdateshort -replace 'serial', $hash1.Serial[$i] -replace 'ipaddr', $hash1.ipaddress[$i] -replace 'assettag', $hash1.assettag[$i] -replace 'active', $hash1.Ciactive[$i] -replace 'status', $hash1.Cistatus[$i] -replace 'MAC', $hash1.MACaddress[$i] -replace 'model', $hash1.cimodel[$i]
        testfilewrite "$edline" "$Interfacenaam"
       }
    LogWrite('Finished creation of testset for interface Database Relations part: SAPLogon')
    $progressbar.PerformStep()

    LogWrite('Starting creation of testset for interface Database Relations part: SAPLogon-cmdb_ci_database')
    $Interfacenaam='cmdb_ci_database'
    $firstline= ('"u_sys_id","virtual","u_cmdb_ci_functional","sys_class_name","u_active","u_marked_for_inactivation","company","company.u_krn_number","department","name","u_customer_ci_name","u_third_party_ci_name","u_sid","operational_status","serial_number","asset_tag","u_function","u_release","version","ip_address","dns_domain","db_server","u_environment","u_external_reference_id","u_availability_group_listener","u_customer_product_model_id.u_product_model.u_categoryref","u_customer_product_model_id.u_product_model","u_customer_product_model_id","support_group","u_overal_res_group","u_ci_responsible_group","sys_updated_on","sys_updated_by","sys_created_on","sys_created_by","u_end_date","u_isis_data_file","u_isis_discovery_model","u_isis_exists","u_isis_first_discovered","u_isis_last_discovered","u_first_discovered","u_last_discovered","u_ci_discovery_name","discovery_source","u_discovered_serialnumber"')
    testfilewrite $firstline $Interfacenaam
    for($i=$partstart; $i -lt $partincrement + $AmountNew; $i++){
            if($i -lt [int]$nok){  
                $editline= ('"sysid","false","true","Database","true","false","KPN","8001206483","BO KPN Retail","dbnme.KPN.name","","","dbnme","In use","","","SAP HANA","","","","dummy.lan","name","PRD","","","Database (Class)","Database (Class)","SAP HANA","BO KPN Retail","KPN-OPS N&I ACN WS-DevOps","KITS-IT-SAP","datum","KPNNL\dummy","2016-04-13 14:33:47","KPNNL\dummy","","","","true","","","","","","SAP Logon",""')
                $edline=$editline -replace 'sysid',$hash1.sid[$i]  -replace 'name',$hash1.devicename[$i] -replace 'dbnme',$hash1.dbrelease[$i] -replace 'datum',$altdatelong -replace 'serial', $hash1.Serial[$i] -replace 'ipaddr', $hash1.ipaddress[$i] -replace 'assettag', $hash1.assettag[$i] -replace 'ciactive', $hash1.ciactive[$i] -replace 'powerstate', $hash1.powerstate[$i] -replace 'lastsee', $hash1.lastseen[$i]  -replace 'ram',$hash1.ciram[$i]  -replace 'cpucore',$hash1.cicpu[$i] -replace 'vcpu',$hash1.civcpu[$i]
                testfilewrite "$edline" "$Interfacenaam"}
             
        $editline= ('"sysid","false","true","Database","true","false","KPN","8001206483","BO KPN Retail","dbnme.KPN.name","","","dbnme","In use","","","SAP HANA","","","","dummy.lan","name","PRD","","","Database (Class)","Database (Class)","SAP HANA","BO KPN Retail","KPN-OPS N&I ACN WS-DevOps","KITS-IT-SAP","datum","KPNNL\dummy","2016-04-13 14:33:47","KPNNL\dummy","","","","true","","","","","","SAP Logon",""')
        $edline=$editline -replace 'sysid',$hash1.sid[$i]  -replace 'name',$hash1.devicename[$i] -replace 'dbnme',$hash1.dbrelease[$i] -replace 'datum',$altdatelong -replace 'serial', $hash1.Serial[$i] -replace 'ipaddr', $hash1.ipaddress[$i] -replace 'assettag', $hash1.assettag[$i] -replace 'ciactive', $hash1.ciactive[$i] -replace 'powerstate', $hash1.powerstate[$i] -replace 'lastsee', $hash1.lastseen[$i]  -replace 'ram',$hash1.ciram[$i]  -replace 'cpucore',$hash1.cicpu[$i] -replace 'vcpu',$hash1.civcpu[$i]
        testfilewrite "$edline" "$Interfacenaam"
        }
       
    LogWrite('Finished creation of testset part SAPLogon for interface database part: SAPLogon-cmdb_ci_database')  
    $progressbar.PerformStep()
    return $partcounter
}


# Function generate testdata cloud2cmdb 
$continue=1
Function cloud2cmdb{
LogWrite('Starting creation of testset for interface database part: cloud2cmdb')
# increment partcounter for this part
$partcounter=$continue + 1
# now the partcounter is used to compute the part increment so this part of the total amount of hash records will receive the right amount of hash records
$partincrement=$partcounter * $amntprt
$partstart=$partincrement - $amntprt
$Interfacenaam='cloud2cmdb'
    $firstline= ('databasename ,instancenames ,database_type ,version, hostname ,cluster_naam ,domain ,last_update ,last_collect,customer ,release_naam ,release ,ci_responsiblegroup ,instance_host_relatie')
    testfilewrite $firstline $Interfacenaam
    for($i=$partstart; $i -lt ([int]$partstart + $records + [int]$new); $i++){
         if($i -lt ([int]$partstart + [int]$update)){
            for($w=1;$w -le [int]$update;$w++){
                $editline= ('"dbnme","name","Single_instance","Enterprise Edition","name","","dummy.lan","","datum","KPN B.V.","dbrelease","12.1.0.1.0","KITS-IT-SAP","name-name"')                         
                    $edline=$editline -replace 'sysid',$hash1.sid[$i]  -replace 'name',$hash1.devicename[$i] -replace 'dbnme',$hash1.cidbname[$i] -replace 'dbrelease',$hash1.altdbrelease[$w-1]  -replace 'database',$hash1.cidbmodel[$i] -replace 'datum',$altdateHorus -replace 'serial', $hash1.Serial[$i] -replace 'ipaddr', $hash1.ipaddress[$i] -replace 'assettag', $hash1.assettag[$i] -replace 'ciactive', $hash1.altciactive[$i] -replace 'powerstate', $hash1.altpowerstate[$i] -replace 'lastsee', $hash1.altlastseen[$i]  -replace 'ram',$hash1.altciram[$i]  -replace 'cpucore',$hash1.altcicpu[$i] -replace 'vcpu',$hash1.altcivcpu[$i]
                    testfilewrite "$edline" "$Interfacenaam"
                    $i++
                    continue
                    }
                }
            $editline= ('"dbnme","name","Single_instance","Enterprise Edition","name","","dummy.lan","","datum","KPN B.V.","dbrelease","12.1.0.2.0","KITS-IT-SAP","name-name"')                         
            $edline=$editline -replace 'sysid',$hash1.sid[$i]  -replace 'name',$hash1.devicename[$i] -replace 'dbnme',$hash1.cidbname[$i] -replace 'dbrelease',$hash1.dbrelease[$i]  -replace 'database',$hash1.cidbmodel[$i] -replace 'datum',$altdateHorus -replace 'serial', $hash1.Serial[$i] -replace 'ipaddr', $hash1.ipaddress[$i-1] -replace 'assettag', $hash1.assettag[$i-1] -replace 'ciactive', $hash1.ciactive[$i-1] -replace 'powerstate', $hash1.powerstate[$i] -replace 'lastsee', $hash1.lastseen[$i]  -replace 'ram',$hash1.ciram[$i]  -replace 'cpucore',$hash1.cicpu[$i] -replace 'vcpu',$hash1.civcpu[$i]
            testfilewrite "$edline" "$Interfacenaam" 
        }
        
#Now add the other part of the baseline
    $Interfacenaam='cmdb_ci_database'
    for($i=$partstart; $i -lt $partincrement; $i++){
        $editline= ('"sysid","false","true","Database","true","false","KPN B.V.","8001206483","","dbnme.name","","","name","","","","","12.1.0.2.0","Enterprise Edition","","dummy.lan","name","p","","","Database (Class)","Database (Class)","ORACLE 12.1.0.2.0 Enterprise Edition","","","KITS-IT-SAP","datum","KPNNL\dummy","2016-04-13 14:33:47","KPNNL\dummy","","","","false","","","","","","eCMDB",""')
        if($i -lt ([int]$w + [int]$nok)){
            $edline=$editline -replace 'sysid',$hash1.sid[([int]$i - [int]$new)]  -replace 'name',$hash1.devicename[$i] -replace 'dbnme',$hash1.cidbname[$i] -replace 'datum',$altdatelong -replace 'serial', $hash1.Serial[$i] -replace 'ipaddr', $hash1.ipaddress[$i] -replace 'assettag', $hash1.assettag[$i] -replace 'ciactive', $hash1.ciactive[$i] -replace 'powerstate', $hash1.powerstate[$i] -replace 'lastsee', $hash1.lastseen[$i]  -replace 'ram',$hash1.ciram[$i]  -replace 'cpucore',$hash1.cicpu[$i] -replace 'vcpu',$hash1.civcpu[$i]
            testfilewrite "$edline" "$Interfacenaam"}
        else{$edline=$editline -replace 'sysid',$hash1.sid[([int]$i - [int]$new)]  -replace 'name',$hash1.devicename[$i] -replace 'dbnme',$hash1.cidbname[$i] -replace 'datum',$altdatelong -replace 'serial', $hash1.Serial[$i] -replace 'ipaddr', $hash1.ipaddress[$i] -replace 'assettag', $hash1.assettag[$i] -replace 'ciactive', $hash1.ciactive[$i] -replace 'powerstate', $hash1.powerstate[$i] -replace 'lastsee', $hash1.lastseen[$i]  -replace 'ram',$hash1.ciram[$i]  -replace 'cpucore',$hash1.cicpu[$i] -replace 'vcpu',$hash1.civcpu[$i]
             testfilewrite "$edline" "$Interfacenaam"}
        }
       return $partcounter
       LogWrite('Finished creation of testset for interface database part: cloud2cmdb') 
       $progressbar.PerformStep()
}


#-------------------------------------------------------------------------------------------------------------------
LogWrite 'Start script'
LogWrite "Module voor $interface deel $part gestart met $records records $new nieuwe $update updates en $nok NOK"
$amntsource=countsource $interface
$amountall=[int]$records * [int]$amntsource[0]
$amntprt=[math]::round($amountall/$amntsource)
$hash1=GenCI
invoke-expression "$part"
$progressbar.PerformStep()