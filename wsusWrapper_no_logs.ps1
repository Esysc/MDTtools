# Run windows update offline
# You can update this local repo by running the dedicated script in sh directory

#Setting Vars 

$DoUpdate = "DoUpdate.cmd"
cd Z:\MDT\Scripts\wsusoffline\client\cmd
#Performing Action 


#Start the updates

& .\$DoUpdate
 
exit 3010
