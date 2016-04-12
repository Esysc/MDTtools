FOR /F "skip=2" %%G IN ('npackdcl list-repos') DO (
 npackdcl remove-repo --url=%%G
 )