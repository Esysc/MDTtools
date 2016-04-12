param([string]$msg = "msg", [string]$url = "url")

$msg = "$args[0]"
$url = "$args[1]"

$body = @{
    status = "$msg"
}

Invoke-RestMethod $url -Method Post -ContentType "json" -Body (ConvertTo-Json $body) -UserAgent "perl"
