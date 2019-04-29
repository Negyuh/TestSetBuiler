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
foreach($ci in (1..($amountall+ ([int]$anmnw * [int]$amntsource) + $new))){
    Set-Variable -Name "CISIDtmp" -Value (-join ((48..57) + (97..122) | Get-Random -Count 32 | % {[char]$_}))
    [array]$cisid += $cisidtmp
    Set-Variable -Name "CISIDtmp2" -Value (-join ((48..57) + (97..122) | Get-Random -Count 32 | % {[char]$_}))
    [array]$cisid2 += $cisidtmp2
    Set-Variable -Name "CISIDtmp3" -Value (-join ((48..57) + (97..122) | Get-Random -Count 32 | % {[char]$_}))
    [array]$cisid3 += $cisidtmp3
    Set-Variable -Name "CIName$ci" -value "DEV$ci"
    [array]$ciname += "CIName$ci"
    Set-Variable -Name "company1" -value "KPN"
    [array]$company += "$company1"
    Set-Variable -Name "department1" -value "BO KPN Retail"
    [array]$department +=$department1
    Set-Variable -Name "serial" -Value (-join ((48..57)  | Get-Random -Count 32 | % {[char]$_}))
    [array]$serialnumber += "$serial"
    Set-Variable -Name "altserial" -Value (-join ((48..57) + (97..122) | Get-Random -Count 10 | % {[char]$_}))
    [array]$altserialnumber += "$altserial"
    [array]$devicename += "DEV$ci"
    [array]$altdevicename += "PUFF$ci"
    [array]$Ipaddress += "10.245.143.$ci"
    [array]$assettag += "CI123$ci"
    Set-Variable -Name MACaddress -Value ((0..5 | ForEach-Object { '{0:x}{1:x}' -f (Get-Random -Minimum 0 -Maximum 15),(Get-Random -Minimum 0 -Maximum 15)})  -join ':')
    [array]$macaddr += $MACaddress
    Set-Variable -Name 'status' -Value 'In use'
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
    for($m=1;$m -le ($amountall+ ([int]$anmnw * [int]$amntsources) + $new);$m++ ){
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
    for($m=1;$m -le (($amountall+ ([int]$anmnw * [int]$amntsource) + $new) + [int]$new);$m++ ){
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
                   [array]$altdbrelease +=$dbrelease2
                   $company2= 'Edea'
                   [array]$altcompany +=$company2
                   $department2= 'BO Customer 1 KPN'
                   [array]$altdepartment +=$department2}
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
                   $company2= 'KPN consulting'
                   [array]$altcompany +=$company2
                   $department2= 'DummyDeprt KPN'
                   [array]$altdepartment +=$department2
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
                   $company2= 'VDL'
                   [array]$altcompany +=$company2
                   $department2= 'Reat Support'
                   [array]$altdepartment +=$department2
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
        altname=@($altdevicename)
        altciram= @($altciram)
        altCistatus= @($altcistatus)
        altcivcpu= @($altvcpu)
        altcompany=@($altcompany)
        altdepartment=($altdepartment)
        altdatelong= @($altdatelong)
        altdateHorus= @($altdateHorus)
        altLastseen= @($altlastseen)
        altPowerState= @($altpowerstate)
        altSerial= @($altserialnumber)
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
        company=@($company)
        department=@($department)
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
        sid3= @($cisid3)
        uuid= @($ciuuid3)
        xmlconns= @($xlconnections)
        xmlfavo= @($xlfavorites)
        xmlshort= @($xlshortcuts)
        }
     return $hash
    }
  
#-------------------------------------------------------------------------------------------------------------------
# Function generate testdata cloud2cmdb 
$continue=0
Function cloud2cmdb{
LogWrite('Starting creation of testset for interface database_relations part: cloud2cmdb')
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
                $editline= ('"dbnme","BAREU","Single_instance","Enterprise Edition","name","","kpn.local","","datum","KPN","dbrelease","12.1.0.1.0","KPN-OPS BO BITO-BA Application Mgmt 1-Oracle","BAREU-name"')                         
                    $edline=$editline -replace 'sysid',$hash1.sid[$i]  -replace 'name',$hash1.altname[$i] -replace 'dbnme',$hash1.cidbname[$i] -replace 'dbrelease',$hash1.altdbrelease[$w-1]  -replace 'database',$hash1.cidbmodel[$i] -replace 'datum',$altdateHorus -replace 'serial', $hash1.Serial[$i] -replace 'ipaddr', $hash1.ipaddress[$i] -replace 'assettag', $hash1.assettag[$i] -replace 'ciactive', $hash1.altciactive[$i] -replace 'powerstate', $hash1.altpowerstate[$i] -replace 'lastsee', $hash1.altlastseen[$i]  -replace 'ram',$hash1.altciram[$i]  -replace 'cpucore',$hash1.altcicpu[$i] -replace 'vcpu',$hash1.altcivcpu[$i]
                    testfilewrite "$edline" "$Interfacenaam"
                    $i++
                    continue
                    }
                }
            $editline= ('"dbnme","BAREU","Single_instance","Enterprise Edition","name","","kpn.local","","datum","KPN","dbrelease","12.1.0.2.0","KPN-OPS BO BITO-BA Application Mgmt 1-Oracle","BAREU-name"')                         
            $edline=$editline -replace 'sysid',$hash1.sid[$i]  -replace 'name',$hash1.devicename[$i] -replace 'dbnme',$hash1.cidbname[$i] -replace 'dbrelease',$hash1.dbrelease[$i]  -replace 'database',$hash1.cidbmodel[$i] -replace 'datum',$altdateHorus -replace 'serial', $hash1.Serial[$i] -replace 'ipaddr', $hash1.ipaddress[$i-1] -replace 'assettag', $hash1.assettag[$i-1] -replace 'ciactive', $hash1.ciactive[$i-1] -replace 'powerstate', $hash1.powerstate[$i] -replace 'lastsee', $hash1.lastseen[$i]  -replace 'ram',$hash1.ciram[$i]  -replace 'cpucore',$hash1.cicpu[$i] -replace 'vcpu',$hash1.civcpu[$i]
            testfilewrite "$edline" "$Interfacenaam"           
        }
     $RelprogressBar.PerformStep()
     LogWrite('Finished creation of testset for interface database_relations part: cloud2cmdb')
        
#Now add the  part of the combined baseline
    LogWrite('Starting creation of testset for interface database_relations part: combined_servicenow_relations_tmp_database')
    $Interfacenaam='combined_servicenow_relations_tmp_database'
    $firstline= ('sys_id,parent,type,child,connection_strength,sys_created_on,sys_created_by,sys_updated_by,parent_u_sys_id,parent_company,parent_company_u_krn_number,parent_sys_class_name,parent_u_customer_product_model_id,parent_u_customer_product_model_id_categoryref,parent_u_active,parent_name,parent_u_isis_exists,child_u_sys_id,child_company,child_company_u_krn_number,child_sys_class_name,child_u_customer_product_model_id,child_u_customer_product_model_id_categoryref,child_u_active,child_name,child_u_isis_exists')
    testfilewrite $firstline $Interfacenaam
    for($i=$partstart; $i -lt $partincrement; $i++){
        $editline='"cizid","sysid","Connects to::Connected by","cisid2","always","altdatelong","KPNNL\dummy","KPNNL\dummy","sysid2","KPN","1002151856","Database","SAP HANA",,"true","dbnme.name","true","sysid3","KPN",,"Server","VMware Virtual Platform (Model)",,"true","name","true"'
        if($i -lt ([int]$w + [int]$nok)){
            $edline=$editline -replace 'sysid',$hash1.sid[$i] -replace 'altdatelong',$hash1.altdatelong -replace 'dbnme',$hash1.cidbname[$i] -replace 'cisid2',$hash1.sid2[$i]-replace 'cizid',$hash1.sid3[$i] -replace 'name',$hash1.devicename[$i] -replace 'datum',$sevendaysago -replace 'serial', $hash1.Serial[$i] -replace 'ipaddr', $hash1.ipaddress[$i] -replace 'assettag', $hash1.assettag[$i] -replace 'active', $hash1.Ciactive[$i] -replace 'status', $hash1.Cistatus[$i] -replace 'MAC', $hash1.MACaddress[$i] -replace 'model', $hash1.cimodel[$i]
            testfilewrite "$edline" "$Interfacenaam"}
        else{$edline=$editline -replace 'sysid',$hash1.sid[$i] -replace 'altdatelong',$hash1.altdatelong -replace 'dbnme',$hash1.cidbname[$i] -replace 'cisid2',$hash1.sid2[$i]-replace 'cizid',$hash1.sid3[$i] -replace 'name',$hash1.devicename[$i] -replace 'datum',$sevendaysago -replace 'serial', $hash1.Serial[$i] -replace 'ipaddr', $hash1.ipaddress[$i] -replace 'assettag', $hash1.assettag[$i] -replace 'active', $hash1.Ciactive[$i] -replace 'status', $hash1.Cistatus[$i] -replace 'MAC', $hash1.MACaddress[$i] -replace 'model', $hash1.cimodel[$i]
             testfilewrite "$edline" "$Interfacenaam"}
            }    
       $RelprogressBar.PerformStep()
       LogWrite('Finished creation of testset for interface databaserelations part: combined_servicenow_relations_tmp_database') 


#Add the  part of the baseline Server
    LogWrite('Starting creation of testset for interface database_relations part: cmdb_ci_server')
    $Interfacenaam='cmdb_ci_server'
    $firstline= ('"u_sys_id","name","company","serial_number","asset_tag","u_system_name","u_datacenter","location","u_datacenter_responsible_group","u_computer_room","u_rack","u_isis_discovery_model","department","assigned_to","operational_status","install_status","sys_class_name","category","manufacturer","u_customer_product_model_id","model_number","u_ci_type","support_group","u_ci_discovery_name","virtual","u_active","sys_updated_by","sys_updated_on","u_module_position","u_discovered_serialnumber","dns_domain","u_discovered_os","ram","cpu_count","cpu_core_count","cpu_speed","cpu_type","u_cmdb_ci_functional","purchase_date","u_physical_ci_change_date","mac_address","u_hyperthreading","u_full_system_name","u_ci_responsible_group","u_overal_res_group","company.u_active","u_isis_exists","u_isis_data_file","ip_address","u_ip_address_2","u_ip_address_3","u_ip_address_4","u_ip_address_5","u_ip_address_6","u_ip_address_7","u_ip_address_8","u_remark_operational","company.u_krn_number","u_environment","u_function","u_customer_ci_name","u_third_party_ci_name"')
    testfilewrite $firstline $Interfacenaam
    for($i=$partstart; $i -lt ($partincrement + [int]$new); $i++){
        $editline='"sysid","name","company","altserial","assettag","name","Data Center AmsterdamZO","NL_1105AG_1-3_DCPBW_Floor0_AMSTERDAMZO","KITS-IT-Housing-Floor Management","DCPBW_Magazijn EOL","","","","","in_use","","Server","Hardware","Cisco","Cisco B200 Blade Server (Model)","","","KPN-OPS BO BITO-BA Application Mgmt 2","name","false","true","KPNNL\dummy","altdatehorus","","QCI1531AC2J","kpn.local","Red Hat 5.7 (Enterprise Server 64 bits)","23552","1","6","2600","Intel(R) Xeon(R) CPU X5650  @ ","false","dateshort","","","true","name.kpn.local","KPN-OPS BO BITO-BA Application Mgmt 2","KPN-OPS BO BITO-BA Application Mgmt","true","true","orion_server_exists","ipaddr","","","","","","","","","7081609236","PRD",""," ",""'
        if($i -lt ([int]$w + [int]$nok)){
            $edline=$editline -replace 'sysid',$hash1.sid2[([int]$i - [int]$new)] -replace 'company', $hash1.company[$i] -replace 'name',$hash1.devicename[$i] -replace 'dbnme',$hash1.cidbname[$i] -replace 'altdatehorus',$altdateHorus -replace 'dateshort',$dateshort -replace 'datum',$altdatelong -replace 'altserial', $hash1.Altserial[$i] -replace 'serial', $hash1.Serial[$i] -replace 'ipaddr', $hash1.ipaddress[$i] -replace 'assettag', $hash1.assettag[$i] -replace 'ciactive', $hash1.ciactive[$i] -replace 'powerstate', $hash1.powerstate[$i] -replace 'lastsee', $hash1.lastseen[$i]  -replace 'ram',$hash1.ciram[$i]  -replace 'cpucore',$hash1.cicpu[$i] -replace 'vcpu',$hash1.civcpu[$i]
            testfilewrite "$edline" "$Interfacenaam"}
        else{$edline=$editline -replace 'sysid',$hash1.sid2[([int]$i - [int]$new)] -replace 'company', $hash1.company[$i] -replace 'name',$hash1.devicename[$i] -replace 'dbnme',$hash1.cidbname[$i] -replace 'altdatehorus',$altdateHorus -replace 'dateshort',$dateshort -replace 'datum',$altdatelong -replace 'altserial', $hash1.Altserial[$i] -replace 'serial', $hash1.Serial[$i] -replace 'ipaddr', $hash1.ipaddress[$i] -replace 'assettag', $hash1.assettag[$i] -replace 'ciactive', $hash1.ciactive[$i] -replace 'powerstate', $hash1.powerstate[$i] -replace 'lastsee', $hash1.lastseen[$i]  -replace 'ram',$hash1.ciram[$i]  -replace 'cpucore',$hash1.cicpu[$i] -replace 'vcpu',$hash1.civcpu[$i]
             testfilewrite "$edline" "$Interfacenaam"}
        }    
       $RelprogressBar.PerformStep()
       LogWrite('Finished creation of testset for interface database_relations part: cmdb_ci_server') 

#Now add the  part of the baseline database
#Now add the database part of the baseline
    LogWrite('Starting creation of testset for interface databaserelations part: cmdb_ci_database')
    $Interfacenaam='cmdb_ci_database'
    $firstline='"u_sys_id","virtual","u_cmdb_ci_functional","sys_class_name","u_active","u_marked_for_inactivation","company","company.u_krn_number","department","name","u_customer_ci_name","u_third_party_ci_name","u_sid","operational_status","serial_number","asset_tag","u_function","u_release","version","ip_address","dns_domain","db_server","u_environment","u_external_reference_id","u_availability_group_listener","u_customer_product_model_id.u_product_model.u_categoryref","u_customer_product_model_id.u_product_model","u_customer_product_model_id","support_group","u_overal_res_group","u_ci_responsible_group","sys_updated_on","sys_updated_by","sys_created_on","sys_created_by","u_end_date","u_isis_data_file","u_isis_discovery_model","u_isis_exists","u_isis_first_discovered","u_isis_last_discovered","u_first_discovered","u_last_discovered","u_ci_discovery_name","discovery_source","u_discovered_serialnumber"'
    testfilewrite $firstline $Interfacenaam
    for($i=$partstart; $i -lt ($partincrement + [int]$new); $i++){
            $editline='"sysid","false","true","Database","true","false","KPN","","","dbnme.name","","","","In use","","","","","","","","","","","","Database (Class)","SAP HANA"," SAP HANA","","KPN-OPS BO BITO-BA ERP-Team BA Application Mgmt","KPN-OPS BO BITO-BA ERP-Team BA Application Mgmt","datum","ADM.SWN","2016-04-13 14:33:47","KPNNL\dummy","","","","false","","","","","","",""'
        if($i -lt ([int]$w + [int]$nok)){
            $edline=$editline -replace 'sysid',$hash1.sid[$i] -replace 'dbnme',$hash1.cidbname[$i] -replace 'name',$hash1.devicename[$i] -replace 'nameicename',$hash1.devicename[$i] -replace 'datum',$altdatelong -replace 'serial', $hash1.Serial[$i] -replace 'ipaddr', $hash1.ipaddress[$i] -replace 'assettag', $hash1.assettag[$i] -replace 'active', $hash1.Ciactive[$i] -replace 'status', $hash1.Cistatus[$i] -replace 'MAC', $hash1.MACaddress[$i] -replace 'model', $hash1.cimodel[$i]
            testfilewrite "$edline" "$Interfacenaam"}
        else{#$editline='"sysid","false","true","Database","true","false","KPN","",""," SAP SQL Anywhere 12.0 (Model)","","","","In use","","","","","","","","","","","","Database (Class)","SAP SQL Anywhere 12.0 (Model)"," SAP SQL Anywhere 12.0 (Model)","","KPN-OPS BO BITO-BA ERP-Team BA Application Mgmt","KPN-OPS BO BITO-BA ERP-Team BA Application Mgmt","datum","ADM.SWN","2016-04-13 14:33:47","KPNNL\dummy","","","","false","","","","","","",""'
            $edline=$editline -replace 'sysid',$hash1.sid[$i] -replace 'company',$hash1.company[$i] -replace 'name',$hash1.devicename[$i]  -replace 'status', $hash1.Cistatus[$i]  -replace 'name',$hash1.devicename[$i] -replace 'dbnme',$hash1.cidbname[$i] -replace 'datum',$altdatelong -replace 'serial', $hash1.Serial[$i] -replace 'ipaddr', $hash1.ipaddress[$i] -replace 'assettag', $hash1.assettag[$i] -replace 'shortdate', $altdateshort -replace 'ciactive', $hash1.ciactive[$i] -replace 'powerstate', $hash1.powerstate[$i] -replace 'lastsee', $hash1.lastseen[$i]  -replace 'ram',$hash1.ciram[$i]  -replace 'cpucore',$hash1.cicpu[$i] -replace 'vcpu',$hash1.civcpu[$i]
            testfilewrite "$edline" "$Interfacenaam"           
            }
        }
    $RelprogressBar.PerformStep()
    LogWrite('Finished creation of testset part interface database_relations part: cmdb_ci_database')  
    return $partcounter
}

Function CMDB_SAPLogon_CSV{
# increment partcounter for this part
$partcounter=2
# now the partcounter is used to compute the part increment so this part of the total amount of hash records will receive the right amount of hash records
$partincrement=$partcounter * $amntprt
$partstart=$partincrement - $amntprt
    LogWrite('Starting creation of testset for interface Database Relations part: SAPLogon')
    $Interfacenaam='CMDB_SAPLogon'
    $firstline= ('SAPversion;SAPfile;SAP_Company;SAP_Department;SAP_Identifier;SAP_Company_code;SAP_release;SAP_cpm_inst;SAP_Environment;SAP_SID;SAP_SID_DB;SAP_Instance_name;SAP_Instance_number;SAP_Hostname;SAP_Database;SAP_Instance;SAP_System;SAP_Status;Filename;Discoverydate')
    testfilewrite $firstline $Interfacenaam
    for($i=$partstart; $i -lt ([int]$partstart + [int]$amntprt + [int]$new); $i++){
        if($i -lt ($update + $partstart)){
            for($w=1;$w -le $update;$w++){
                $editline='"";"";"company";"BO KPN Retail";"company (HANA 2.0 SPS3 - PRD) - SAAS DB (name 18)";"company";"HANA 2.0 SPS3";"DB";"PRD";"SAAS";"";"name";"18";"name";"company.SAAS";"KPN_name_18";"SAAS_company";"status";"SAPUILandscape";"altdatelong"'
                $edline=$editline -replace 'sysid',$hash1.sid[$i]  -replace 'altdatelong',$hash1.altaltdatelong  -replace 'name',$hash1.altname[$i] -replace 'dbnme',$hash1.dbrelease[$i] -replace 'datum',$altdatelong -replace 'date',$altdateshort -replace 'status', $hash1.altcistatus[$i] -replace 'company', $hash1.company[$i] -replace 'assettag', $hash1.assettag[$i] -replace 'active', $hash1.Ciactive[$i] -replace 'status', $hash1.altcistatus[$i] -replace 'MAC', $hash1.MACaddress[$i] -replace 'model', $hash1.cimodel[$i]
                testfilewrite "$edline" "$Interfacenaam"
                $i++
                continue
                } 
            }  
        #corection $i for right value of $i
        #$i=$i-1
        $editline='"";"";"company";"BO KPN Retail";"company (HANA 2.0 SPS3 - PRD) - SAAS DB (name 18)";"company";"HANA 2.0 SPS3";"DB";"PRD";"SAAS";"";"name";"18";"name";"company.SAAS";"KPN_name_18";"SAAS_company";"status";"SAPUILandscape";"altdatelong"'
        $edline=$editline -replace 'sysid',$hash1.sid[$i]  -replace 'altdatelong',$hash1.altaltdatelong  -replace 'name',$hash1.devicename[$i] -replace 'dbnme',$hash1.dbrelease[$i] -replace 'datum',$altdatelong -replace 'date',$altdateshort -replace 'serial', $hash1.Serial[$i] -replace 'company', $hash1.company[$i] -replace 'assettag', $hash1.assettag[$i] -replace 'active', $hash1.Ciactive[$i] -replace 'status', $hash1.Cistatus[$i] -replace 'MAC', $hash1.MACaddress[$i] -replace 'model', $hash1.cimodel[$i]
        testfilewrite "$edline" "$Interfacenaam" 
        #now add 1 for partcounter to $i
        #$i=$i+1  
       }
    $RelprogressBar.PerformStep()
    LogWrite('Finished creation of testset for interface Database Relations part: SAPLogon')


#Now add the server part of the combined baseline
    LogWrite('Starting creation of testset for interface databaserelations part: combined_servicenow_relations_tmp_database')
    $Interfacenaam='combined_servicenow_relations_tmp_database'
    for($i=$partstart; $i -lt $partincrement; $i++){           
        if($i -ne ([int]$amntprt - 1)){     
            $editline='"cisid","sysid","Connects to::Connected by","cizid","always","altdatelong","KPNNL\dummy","KPNNL\dummy","sysid2","KPN","1002151856","Database","HANA",,"true","SAAS.company.name","true","sysid3","KPN",,"Server","VMware Virtual Platform (Model)",,"true","name","true"'
            $edline=$editline -replace 'sysid',$hash1.sid[$i] -replace 'altdatelong',$altdatelong -replace 'company', $hash1.company[$i] -replace 'dbnme',$hash1.cidbname[$i] -replace 'cizid',$hash1.sid2[$i] -replace 'cisid',$hash1.sid3[$i] -replace 'name',$hash1.devicename[$i] -replace 'datum',$sevendaysago -replace 'serial', $hash1.Serial[$i] -replace 'ipaddr', $hash1.ipaddress[$i] -replace 'assettag', $hash1.assettag[$i] -replace 'active', $hash1.Ciactive[$i] -replace 'status', $hash1.Cistatus[$i] -replace 'MAC', $hash1.MACaddress[$i] -replace 'model', $hash1.cimodel[$i]
            testfilewrite "$edline" "$Interfacenaam"
             if($i -lt [int]$nok){  
            #$editline='"cisid","sysid","Connects to::Connected by","cizid","always","altdatelong","KPNNL\dummy","KPNNL\dummy","sysid2","KPN","1002151856","Database","HANA",,"true","SAAS.company.name","true","sysid3","KPN",,"Server","VMware Virtual Platform (Model)",,"true","name","true"'
            $edline=$editline -replace 'sysid',$hash1.sid[$i] -replace 'altdatelong',$altdatelong -replace 'company', $hash1.company[$i] -replace 'dbnme',$hash1.cidbname[$i] -replace 'cizid',$hash1.sid2[$i] -replace 'cisid',$hash1.sid3[$i] -replace 'name',$hash1.devicename[$i] -replace 'datum',$sevendaysago -replace 'serial', $hash1.Serial[$i] -replace 'ipaddr', $hash1.ipaddress[$i] -replace 'assettag', $hash1.assettag[$i] -replace 'active', $hash1.Ciactive[$i] -replace 'status', $hash1.Cistatus[$i] -replace 'MAC', $hash1.MACaddress[$i] -replace 'model', $hash1.cimodel[$i]
                testfilewrite "$edline" "$Interfacenaam"}
            }
        else{
            $editline='"cisid","sysid","Connects to::Connected by","cizid","always","altdatelong","KPNNL\dummy","KPNNL\dummy","sysid2","KPN","1002151856","Database","HANA",,"true","SAAS.company.name","true","sysid3","KPN",,"Server","VMware Virtual Platform (Model)",,"true","name","true"'
            $edline=$editline -replace 'sysid',$hash1.sid[$i] -replace 'altdatelong',$altdatelong -replace 'company', $hash1.company[$i] -replace 'dbnme',$hash1.cidbname[$i] -replace 'cizid',$hash1.sid2[$i] -replace 'cisid',$hash1.sid3[$i] -replace 'name',$hash1.devicename[$i] -replace 'datum',$sevendaysago -replace 'serial', $hash1.Serial[$i] -replace 'ipaddr', $hash1.ipaddress[$i] -replace 'assettag', $hash1.assettag[$i] -replace 'active', $hash1.Ciactive[$i] -replace 'status', $hash1.Cistatus[$i] -replace 'MAC', $hash1.MACaddress[$i] -replace 'model', $hash1.cimodel[$i]
            testfilewrite "$edline" "$Interfacenaam"           
    }
    $RelprogressBar.PerformStep()    
    #return $partcounter
    }
    LogWrite('Finished creation of testset part interface databaserelations part: combined_servicenow_relations_tmp_database') 

#Add the  part of the baseline Server
    LogWrite('Starting creation of testset for interface database_relations part: cmdb_ci_server')
    $Interfacenaam='cmdb_ci_server'
    #$firstline= ('"u_sys_id","name","company","serial_number","asset_tag","u_system_name","u_datacenter","location","u_datacenter_responsible_group","u_computer_room","u_rack","u_isis_discovery_model","department","assigned_to","operational_status","install_status","sys_class_name","category","manufacturer","u_customer_product_model_id","model_number","u_ci_type","support_group","u_ci_discovery_name","virtual","u_active","sys_updated_by","sys_updated_on","u_module_position","u_discovered_serialnumber","dns_domain","u_discovered_os","ram","cpu_count","cpu_core_count","cpu_speed","cpu_type","u_cmdb_ci_functional","purchase_date","u_physical_ci_change_date","mac_address","u_hyperthreading","u_full_system_name","u_ci_responsible_group","u_overal_res_group","company.u_active","u_isis_exists","u_isis_data_file","ip_address","u_ip_address_2","u_ip_address_3","u_ip_address_4","u_ip_address_5","u_ip_address_6","u_ip_address_7","u_ip_address_8","u_remark_operational","company.u_krn_number","u_environment","u_function","u_customer_ci_name","u_third_party_ci_name"')
    #testfilewrite $firstline $Interfacenaam
    for($i=$partstart; $i -lt ($partincrement + [int]$new); $i++){
        $editline='"sysid","name","company","altserial","assettag","name","Data Center AmsterdamZO","NL_1105AG_1-3_DCPBW_Floor0_AMSTERDAMZO","KITS-IT-Housing-Floor Management","DCPBW_Magazijn EOL","","","","","in_use","","Server","Hardware","Cisco","Cisco B200 Blade Server (Model)","","","KPN-OPS BO BITO-BA Application Mgmt 2","name","false","true","KPNNL\dummy","altdatehorus","","QCI1531AC2J","kpn.local","Red Hat 5.7 (Enterprise Server 64 bits)","23552","1","6","2600","Intel(R) Xeon(R) CPU X5650  @ ","false","dateshort","","","true","name.kpn.local","KPN-OPS BO BITO-BA Application Mgmt 2","KPN-OPS BO BITO-BA Application Mgmt","true","true","orion_server_exists","ipaddr","","","","","","","","","7081609236","PRD",""," ",""'
        if($i -lt ([int]$w + [int]$nok)){
            $edline=$editline -replace 'sysid',$hash1.sid2[([int]$i - [int]$new)] -replace 'company', $hash1.company[$i] -replace 'name',$hash1.devicename[$i] -replace 'dbnme',$hash1.cidbname[$i] -replace 'altdatehorus',$altdateHorus -replace 'dateshort',$dateshort -replace 'datum',$altdatelong -replace 'altserial', $hash1.Altserial[$i] -replace 'serial', $hash1.Serial[$i] -replace 'ipaddr', $hash1.ipaddress[$i] -replace 'assettag', $hash1.assettag[$i] -replace 'ciactive', $hash1.ciactive[$i] -replace 'powerstate', $hash1.powerstate[$i] -replace 'lastsee', $hash1.lastseen[$i]  -replace 'ram',$hash1.ciram[$i]  -replace 'cpucore',$hash1.cicpu[$i] -replace 'vcpu',$hash1.civcpu[$i]
            testfilewrite "$edline" "$Interfacenaam"}
        else{$edline=$editline -replace 'sysid',$hash1.sid2[([int]$i - [int]$new)] -replace 'company', $hash1.company[$i] -replace 'name',$hash1.devicename[$i] -replace 'dbnme',$hash1.cidbname[$i] -replace 'altdatehorus',$altdateHorus -replace 'dateshort',$dateshort -replace 'datum',$altdatelong -replace 'altserial', $hash1.Altserial[$i] -replace 'serial', $hash1.Serial[$i] -replace 'ipaddr', $hash1.ipaddress[$i] -replace 'assettag', $hash1.assettag[$i] -replace 'ciactive', $hash1.ciactive[$i] -replace 'powerstate', $hash1.powerstate[$i] -replace 'lastsee', $hash1.lastseen[$i]  -replace 'ram',$hash1.ciram[$i]  -replace 'cpucore',$hash1.cicpu[$i] -replace 'vcpu',$hash1.civcpu[$i]
             testfilewrite "$edline" "$Interfacenaam"}
        }    
       $RelprogressBar.PerformStep()
       LogWrite('Finished creation of testset for interface database_relations part: cmdb_ci_server') 

#Now add the database part of the database baseline
    LogWrite('Starting creation of testset for interface databaserelations part: cmdb_ci_database')
    $Interfacenaam='cmdb_ci_database'
    #$firstline='"u_sys_id","virtual","u_cmdb_ci_functional","sys_class_name","u_active","u_marked_for_inactivation","company","company.u_krn_number","department","name","u_customer_ci_name","u_third_party_ci_name","u_sid","operational_status","serial_number","asset_tag","u_function","u_release","version","ip_address","dns_domain","db_server","u_environment","u_external_reference_id","u_availability_group_listener","u_customer_product_model_id.u_product_model.u_categoryref","u_customer_product_model_id.u_product_model","u_customer_product_model_id","support_group","u_overal_res_group","u_ci_responsible_group","sys_updated_on","sys_updated_by","sys_created_on","sys_created_by","u_end_date","u_isis_data_file","u_isis_discovery_model","u_isis_exists","u_isis_first_discovered","u_isis_last_discovered","u_first_discovered","u_last_discovered","u_ci_discovery_name","discovery_source","u_discovered_serialnumber"'
    #testfilewrite $firstline $Interfacenaam
    for($i=$partstart; $i -lt ($partincrement + [int]$new); $i++){
            $editline='"sysid","false","true","Database","true","false","KPN","","","SAAS.company.name","","","","In use","","","","","","","","","","","","Database (Class)","SAP HANA"," SAP HANA","","KPN-OPS BO BITO-BA ERP-Team BA Application Mgmt","KPN-OPS BO BITO-BA ERP-Team BA Application Mgmt","datum","ADM.SWN","2016-04-13 14:33:47","KPNNL\dummy","","","","false","","","","","","",""'
        if($i -lt ([int]$w + [int]$nok + [int]$partstart)){
            $edline=$editline -replace 'sysid',$hash1.sid[$i] -replace 'company',$hash1.company[$i] -replace 'name',$hash1.devicename[$i] -replace 'datum',$altdatelong -replace 'serial', $hash1.Serial[$i] -replace 'ipaddr', $hash1.ipaddress[$i] -replace 'assettag', $hash1.assettag[$i] -replace 'active', $hash1.Ciactive[$i] -replace 'status', $hash1.Cistatus[$i] -replace 'MAC', $hash1.MACaddress[$i] -replace 'model', $hash1.cimodel[$i]
            testfilewrite "$edline" "$Interfacenaam"}
        else{#$editline='"sysid","false","true","Database","true","false","KPN","",""," SAP SQL Anywhere 12.0 (Model)","","","","In use","","","","","","","","","","","","Database (Class)","SAP SQL Anywhere 12.0 (Model)"," SAP SQL Anywhere 12.0 (Model)","","KPN-OPS BO BITO-BA ERP-Team BA Application Mgmt","KPN-OPS BO BITO-BA ERP-Team BA Application Mgmt","datum","ADM.SWN","2016-04-13 14:33:47","KPNNL\dummy","","","","false","","","","","","",""'
            $edline=$editline -replace 'sysid',$hash1.sid[$i] -replace 'company',$hash1.company[$i] -replace 'status', $hash1.Cistatus[$i]  -replace 'name',$hash1.devicename[$i] -replace 'dbnme',$hash1.dbrelease[$i] -replace 'datum',$altdatelong -replace 'serial', $hash1.Serial[$i] -replace 'ipaddr', $hash1.ipaddress[$i] -replace 'assettag', $hash1.assettag[$i] -replace 'shortdate', $altdateshort -replace 'ciactive', $hash1.ciactive[$i] -replace 'powerstate', $hash1.powerstate[$i] -replace 'lastsee', $hash1.lastseen[$i]  -replace 'ram',$hash1.ciram[$i]  -replace 'cpucore',$hash1.cicpu[$i] -replace 'vcpu',$hash1.civcpu[$i]
            testfilewrite "$edline" "$Interfacenaam"           
            }
        }
 $RelprogressBar.PerformStep()
 LogWrite('Finished creation of testset part interface database_relations part: cmdb_ci_database')
}

#-------------------------------------------------------------------------------------------------------------------
LogWrite 'Start script'
LogWrite "Module voor $interface deel $part gestart met $records records $new nieuwe $update updates en $nok NOK"
$amntsource=countsource $interface
$amountall=[int]$records * [int]$amntsource[0]
$amntexist=(([int]$amountall / $amntsource) - ([int]$new + [int]$nok + [int]$update))
$amntprt=[math]::round($amountall/$amntsource)
$hash1=GenCI
invoke-expression "$part"
$RelprogressBar.PerformStep()