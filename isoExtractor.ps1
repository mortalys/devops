<#
Information:
Extract ISO Images using 7zip

Check 'operations.log' for debuging

Parameters:

    [REQUIRED]
    ISOSource  :: Full Path to ISO file

    [REQUIRED]
    ISODestination  :: Full Path extract the ISO file    

    [OPTIONAL]
    operationsLog :: Full Path to operations log file

    default location "c:\operationsLogging\"


Usage:

Add logical operations/requirements to method 'runOperations' from class 'Commander'

.\IsoExtractor.ps1  <ISOSource> <ISODestination> <operationsLog>

Example:
.\IsoExtractor.ps1  'C:\ISOSource\image.iso' 'C:\ISODestination\' 'C:\operationsLogging\'

#>

#Imports
Using Module ".\Modules\operationsLogging.psm1" 
Using Module ".\Modules\ISOExtractor.psm1"

#get params from shell
<# Production #>
param(
    [Parameter(Mandatory=$true)]
        [string]$ISOSource,
    [Parameter(Mandatory=$true)]
        [string]$ISODestination,        
    [Parameter(Mandatory=$false)]
        [string]$operationsLog
)



<# Development 
param(
    [Parameter(Mandatory=$false)]
        [string]$ISOSource="C:\ISOEXTRACTOR\test.iso",
    [Parameter(Mandatory=$false)]
        [string]$ISODestination="C:\ISOEXTRACTOR\dest\",        
    [Parameter(Mandatory=$false)]
        [string]$operationsLog
)
#>

class DevOps {

    [string]$debuger   

    [bool]runOperations(
               [string]$ISOSource,
               [string]$ISODestination,
               [string]$operationsLogFile)               
    {

        #region « Log Operations »

            #init log class
            $operationsLog = [operationsLogging]::New()

            #set operations log file
            $this.debuger += "Operation: Set Operations Log File `n"
            
            if (!$operationsLog.setLogFile($operationsLogFile)) { 

                $this.debuger += $operationsLog.debuger
                $this.debuger += "`n`n[ FAIL ] `n"  
                
                #output debug log          
                $operationsLog.logAdd($this.debuger, 0)            
                Return $false    
            }
            
            $this.debuger += [string]::Format("Using Log File {0} `n", $operationsLog.filePath)
            $this.debuger += "[ OK ] `n"

        #endregion

        #region « Extractor Operations »

            # init ISOExtractor Operations 
            $ISOExtractor = [ISOExtractor]::New()

            # SET TOOL File
            $this.debuger += "Operation: Check for ISO Tool `n"   

            $ISOTool = @{
                    'name' = '7-Zip';
                    'path' = [string]::Format('{0}\Utils\7z.exe',$PSScriptRoot);
                    'command' = '{0} x -y {1} -o{2}'
                } 

            if (!$ISOExtractor.setToolFile($ISOTool)) {    

                $this.debuger += $ISOExtractor.debuger
                $this.debuger += "`n`n[ FAIL ] `n"              

                #output debug log
                $operationsLog.logAdd($this.debuger, 0)            
                Return $false
            }

            $this.debuger += [string]::Format("Using ISO File {0} ... ", $ISOExtractor.ISOTool['name'])
            $this.debuger += "[ OK ] `n"            

            # SET ISO File
            $this.debuger += "Operation: Check for ISO File `n"        

            if (!$ISOExtractor.setSourceFile($ISOSource)) {    

                $this.debuger += $ISOExtractor.debuger
                $this.debuger += "`n`n[ FAIL ] `n"              

                #output debug log
                $operationsLog.logAdd($this.debuger, 0)            
                Return $false
            }

            $this.debuger += [string]::Format("Using ISO File {0} ... ", $ISOExtractor.Source)
            $this.debuger += "[ OK ] `n"

            # SET Destination folder
            $this.debuger += "Operation: Check for valid destination folder `n"        

            if (!$ISOExtractor.setDestinationFolder($ISODestination)) {    

                $this.debuger += $ISOExtractor.debuger
                $this.debuger += "`n`n[ FAIL ] `n"              

                #output debug log
                $operationsLog.logAdd($this.debuger, 0)            
                Return $false
            }

            $this.debuger += [string]::Format("Using Destination Folder {0} ... ", $ISOExtractor.Destination)
            $this.debuger += "[ OK ] `n"

            # extract ISO
            $this.debuger += "Operation: Extract ISO File ... "            
            if (!$ISOExtractor.Extract()) {    

                $this.debuger += $ISOExtractor.debuger
                $this.debuger += "[ FAIL ] `n"              

                #output debug log
                $operationsLog.logAdd($this.debuger, 0)            
                Return $false
            }
            
            $this.debuger += "[ OK ] `n"            

        #endregion 

        #output debug log
        $operationsLog.logAdd($this.debuger, 1)               

        Return $true
        
    }

}


Write-Host "Starting ISO Extractor Operations..."

#init Commander Object
$c = [DevOps]::New()

<# Production #>
$c.runOperations($PsBoundParameters["ISOSource"],
                 $PsBoundParameters["ISODestination"],
                 $PsBoundParameters["operationsLogFile"])


<# Development 
$c.runOperations($ISOSource,
                 $ISODestination,
                 $PsBoundParameters["operationsLogFile"])
#>

#output Execution Log from Commander 
Write-Host -verbose $c.debuger 