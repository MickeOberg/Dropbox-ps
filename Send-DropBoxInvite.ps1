

#Permission type: Team member management
function Send-DropBoxInvite ($email) {
    
$dbtoken = "YourTokenHere"

$uri='https://api.dropboxapi.com/2/team/members/add '
$headers = @{"Authorization" = "Bearer " + $dbtoken }
$Body = @{
    "new_members" = @(@{  
            "member_email" = ($email);
            "member_given_name" = "";                        
            "member_surname" = "";
            "send_welcome_email" = $true;
         })
}
$json = $Body | ConvertTo-Json
$response = Invoke-RestMethod $uri -Method Post -Headers $headers -Body $json -ContentType 'application/json'

$complete = $response | select -expand .tag
$success = $response | select -expand complete | select -expand .tag

if ($complete -eq "complete" -and $success -eq "success") {Write-Output "Invite sent to $email"}
else {
    $dberror = $response | select -expand complete | select -expand .tag
    Write-Host "Error: $dberror"
}
}