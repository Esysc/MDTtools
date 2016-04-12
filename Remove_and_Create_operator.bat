net user operator /DELETE
net user operator Customer /passwordchg:yes /ADD
net localgroup administrators operator /ADD
net localgroup "Remote Desktop Users" operator /ADD

