class ISOExtractor {

    [string]$debuger

    [string]$Source

    [string]$Destination
    
    $ISOTool = @{
        'name' = '';
        'path' = '';
        'command' = ''
    } 
    
    [Bool]extractorToolsCheck()
    {              
    
        $this.debuger += "`n extractorToolCheck(init)->"           

        Try
        {
            #check if tool exist            
            if (![System.IO.File]::Exists($this.ISOTool['path'])) 
            {   
                $this.debuger += [string]::Format("[ Extractor tool Fails ]({0})", $this.ISOTool['path'])
                Return $false
            }               

            #check if valid ISO file                        
            if (![System.IO.File]::Exists($this.Source)) 
            {   
                $this.debuger += [string]::Format("[ ISO Source file Fails ]({0})", $this.Source)
                Return $false
            }         
            
            #check for destination folder                        
            if (!(Test-Path $this.Destination)) {    
                $this.debuger += [string]::Format("[ ISO Destination Fails ]({0})", $this.Destination)                                             
                Return $false
            }             
        }
        Catch
        {
            return $false
        }	

        $this.debuger += "[ COMPLETE ]"
        return $true
    }

    [Bool]setToolFile($tool)
    {              
    
        $this.debuger += "`n setToolFile(init)->"   
        
        Try
        {
            #check if valid ISO file            
            if (![System.IO.File]::Exists($tool['path'])) 
            {   
                $this.debuger += [string]::Format("[ ISO Tool file not found ]({0})", $tool['path'])

                Return $false
            }

            #assign ISO Tool data 
            $this.ISOTool = $tool
        }
        Catch
        {
            return $false
        }	

        $this.debuger += "[ COMPLETE ]"
        return $true
    }

    [Bool]setSourceFile([string]$file)
    {              
    
        $this.debuger += "`n setSourceFile(init)->"   
           
        Try
        {
            #check if valid ISO file            
            if (![System.IO.File]::Exists($file)) 
            {   
                $this.debuger += [string]::Format("[ ISO Source file not found ]({0})", $file)

                Return $false
            }

            #assign source ISO file
            $this.Source = $file
        }
        Catch
        {
            return $false
        }	

        $this.debuger += "[ COMPLETE ]"
        return $true
    }

    [Bool]setDestinationFolder([string]$destinationFolder)
    {              
    
        $this.debuger += "`n setDestinationFolder(init)->"   
           
        Try
        {
            #check for destination folder            
            $this.debuger += [string]::Format("[ check if destination folder exist ]({0})->", $destinationFolder)
            if (!(Test-Path $destinationFolder)) {                                 
                #create when do not exist

                $this.debuger += "[ creating ]->"
                New-Item -ItemType Directory -Force -Path $destinationFolder
            }             

            #assign destination folder
            $this.Destination = $destinationFolder
        }
        Catch
        {
            return $false
        }	

        $this.debuger += "[ COMPLETE ]"
        return $true
    }

	[Bool]Extract() 
    {	
        $this.debuger += "`n Extract(init)->"

        Try
        {            
            if (!$this.extractorToolsCheck()) 
            {
                return $false    
            }

            #run iso extractor tool            
            $parsedCMD = [string]::Format($this.ISOTool['command'], $this.ISOTool['path'], $this.Source, $this.Destination)

            $this.debuger += [string]::Format("[ Running Command ]({0})", $parsedCMD)
            Invoke-Expression $parsedCMD
        }
        Catch
        {
            return $false
        }	                       

        $this.debuger += "[ COMPLETE ]"
        return $true
	}	
}
