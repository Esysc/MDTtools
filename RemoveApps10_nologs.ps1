#
# Clean of bullshit wins apps
#

#  remove all Modern apps from the system account


Get-AppXProvisionedPackage -online | Remove-AppxProvisionedPackage -online 


#  remove all Modern apps from your all user account

Get-AppxPackage -AllUsers | Remove-AppxPackage 




