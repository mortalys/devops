class operationsLogging {    

    [string]$debuger

    [string]$defaultLogFileLocation = [string]::Format("c:\operationsLogging\operations_{0}.log", [DateTime]::Now.ToString("yyyyMMdd-HHmmss"))    
        
    [string]$filePath

    [Bool]validLogFile([string]$filePath){

        $this.debuger += "`n validLogFile(init)->"

        Try 
        {            
            #check if valid file            
            if (![System.IO.File]::Exists($filePath)) 
            {                
                Return $false
            }   
            
            #set the file location
            $this.filePath = $filePath

            $this.debuger += [string]::Format("[ file exist ]({0})->", $this.filePath)            

        }
        Catch 
        {

            $this.debuger += "Error"
            Return $false
        }

        Return $true
    }

    [Bool]setLogFile([string]$file){

        $this.debuger += "`n setLogFile(init)->"
        
        Try
        {
            $this.debuger += [string]::Format("validLogFile( {0} )->", $file)

            if ($this.validLogFile($file)) {
                return $true
            }

            #use default file location            
            $this.filePath = $this.defaultLogFileLocation

            $this.debuger += [string]::Format("[ using default Log File ]({0})->", $this.filePath)
            
            $loggingDir = [System.IO.Path]::GetDirectoryName($this.filePath)

            #create default log dir when required
            if (-not (Test-Path $loggingDir)) {                 
                New-Item -ItemType Directory -Force -Path $loggingDir
            }            
            
            #create default log file         
            New-Item $this.filePath                
        }
        Catch
        {
            $this.debuger += "Error"
            return $false
        }

        return $true
    }

    [Bool]logAdd([string]$content, [int]$status){

        $this.debuger += "`n log(init)->"

        Try
        {
            #add file operation status to the end of file - Exit Code
            $content += [string]::Format("`n {0}", $status)            
            
            #command to add content to log file
            
            $parsedCMD = [string]::Format("Add-Content -Path {0} -Value '{1}'",
                                            $this.filePath,
                                            $content)      
                                            
            #add log
            $this.debuger += [String]::Format("[ Running Command ]({0})", $parsedCMD)
            
            #run command
            Invoke-Expression $parsedCMD 


        }
        Catch {
            $this.debuger += "Error"
            return $false
        }        
        return $true
    }

}
