$apiVersion = "2017-09-01"
$resourceURI = "https://msistoragedemo.blob.core.windows.net"
$tokenAuthURI = $env:MSI_ENDPOINT + "?resource=$resourceURI&api-version=$apiVersion"
$tokenResponse = Invoke-RestMethod -Method Get -Headers @{"Secret"="$env:MSI_SECRET"} -Uri $tokenAuthURI
$accessToken = $tokenResponse.access_token
$accessToken

$authHeader =   "Bearer " 
$auth = "$($authHeader)$($accessToken)"
$auth
$uri="https://msistoragedemo.blob.core.windows.net/msistorageblobs/parameters.json"
 
$response = Invoke-RestMethod -Method Get -Headers @{"x-ms-version"="2017-11-09";"Authorization" = "$auth"} -Uri $uri
$response | ConvertTo-Json 
#curl https://msistoragedemo.blob.core.windows.net/msistorageblobs/parameters.json -H "x-ms-version: 2017-11-09" -H "$auth"