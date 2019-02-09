# Scott Tearle Feb 9, 2019
# This script assumes you have some familiarity with powershell and execution policies
# Script to check Quickbooks backup log and send emails if it fails.
# This is meant to be run on the database server, not workstation only systems.
#
# I use <> to denote places where you must change the script except for the emailto addresses which are
# a special case
#
# A basic log file of ok and failed backups with timestamps is created to help you find out when your issues
# started so you can recover quickly
#
#
# I recommend setting up a separate drive or network location for your backups.
#
# Copy the original QBBackup.log to a working location so as to not have file lock problems later
# Change <Path to original QBBackup.log>
# The original log file is usually located under
# C:\Users\<the user you installed under>\AppData\Local\Intuit\QuickBooks\Log\QBBackup.log
# Change <Path to working location> throughout the script i.e. E:\QuickbooksBU\QBBackup.log
cp "<Path to original QBBackup.log>" "<Path to working location>"
$data = Get-Content "<Path to working location>\QBBackup.log"
$count = 0
$lastentry = 0
ForEach ($line IN $data){
    $count += 1
    if($line -eq "**********************************************"){
        $lastentry = $count
    }
}
$backupok = $true
for($x=$lastentry; $x -lt $data.Length; $x++){
    if ($data[$x] -like '*Failed*'){
        $backupok = $false
        # Write failure to log
        &{
          Write $(Get-Date)
          Write "Quickbooks backup failure Sending Email"
        } 3>&1 2>&1 >> <Path to working location>\verifyscript.log
        #
        # I use gmail to send my notifications.  You may have to change some of these settings
        # to reflect your email server requirements
        #
        # Change this to a legitimate email address
        $EmailFrom = "someuser@example.com"
        # Powershell's emailer requires you to use an array of 
        # email addresses in the format of  John <user@example.com>
        # the <> must be included
        # if you do not then the email will fail
        $EmailTo = @("User1 <user1@gmail.com>", "User1 <user2@gmail.com>", "User1 <user3@gmail.com>") 
        $Subject = "Notification of Quickbooks backup failure" 
        $Body = $data[$x]
        $SMTPServer = "smtp.gmail.com"
        $SMTPClient = New-Object Net.Mail.SmtpClient($SMTPServer, 587) 
        $SMTPClient.EnableSsl = $true 
        $SMTPClient.Credentials = New-Object System.Net.NetworkCredential("user@example.com", "<password>"); 
        $SMTPClient.Send($EmailFrom, $EmailTo, $Subject, $Body)
    }
}
if($backupok -eq $true){
    &{
        Write $(Get-Date)
        Write "Backup OK"
      } 3>&1 2>&1 >> <Path to working location>\verifyscript.log
}



 
